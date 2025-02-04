class_name NPCCharacter extends Node2D

@onready var bubble_slot : Node2D = $BubbleSlot

@export var base_sprite: Sprite2D
@export var highlight_sprite: Sprite2D

@export var game_status : String
@export var use_state_manager : bool = false

@export var npc_state : String = "Default"

@export var state_mapping : Dictionary

@export var move_position : int = 0

var player_node_in_collision : CharacterBody2D

func _ready() -> void:
	SignalBus.connect("on_state_changed", _resolve_state_change)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name != "PlayerCharacter":
		return
	player_node_in_collision = body
	player_entered()

func _on_area_2d_body_exited(body: Node2D) -> void:
	print("npc exited")
	if body.name != "PlayerCharacter":
		return
	player_exited()	
	player_node_in_collision = null

func player_entered():
	if player_node_in_collision == null || player_node_in_collision.name != "PlayerCharacter":
		return
	toggle_sprite_highlight()
	
	await get_tree().process_frame
	
	if bubble_slot.uses_anchor:
		bubble_slot.start_dialog(_get_closest_bubble_slot_anchor())
	else:
		bubble_slot.start_dialog()
	
	
	player_node_in_collision._get_active_npc_bubble(self)
	GameManager.open_swap_ui()

func player_exited():
	if player_node_in_collision == null || player_node_in_collision.name != "PlayerCharacter":
		return
	toggle_sprite_highlight()
	bubble_slot._end_dialog()
	player_node_in_collision._exit_npc_cleanup(self)
	AudioDialogManager.stop_dialog_play()

func toggle_sprite_highlight():
	if base_sprite != null && highlight_sprite != null:
		base_sprite.visible = !base_sprite.visible
		highlight_sprite.visible = !highlight_sprite.visible
		
func set_sprite_highlight(highlighted):
	if base_sprite != null && highlight_sprite != null:
		base_sprite.visible = !highlighted
		highlight_sprite.visible = highlighted

func apply_new_state(new_state : String, emit : String):
	#if new_state == npc_state:
		#return
	print("Applying state for " + self.name)
	var previous_state = npc_state
	npc_state = new_state
	if !emit.is_empty():
		_resolve_new_state(emit, previous_state)
	#else:
		#print("NPC ["+self.name+"] state not found: "+npc_state)

func _resolve_new_state(emit : String, previous_state : String):
	print("Resolving NEW state for " + self.name)
	if emit == "advance_dialog" && previous_state != npc_state:
		print("Advance dialog for " + self.name)
		bubble_slot.advance_dialog()
		return
	
	SignalBus.on_move_command.emit(emit, self.name)	
	SignalBus.on_state_changed.emit(emit, self.name)
	
func _resolve_state_change(check_value : String, npc_name : String):
	if LevelStateManager.check_subscribers.has(check_value) \
		&&	LevelStateManager.check_subscribers[check_value].has(self.name):
			LevelStateManager.resolve_npc_state(self, check_value)

func flip_sprites():
	base_sprite.flip_h = !base_sprite.flip_h
	highlight_sprite.flip_h = !highlight_sprite.flip_h

func _get_closest_bubble_slot_anchor() -> Control:
	var anchors : Array[Control]
	
	for child in bubble_slot.get_children():
		if child is Control:
			anchors.append(child)
	
	var min_dist = INF
	var min_obj = null
		
	for anchor in anchors:	
		var new_dist = player_node_in_collision.global_position.distance_to(anchor.global_position)
		if new_dist < min_dist:
			min_dist = new_dist
			min_obj = anchor
			
	return min_obj
