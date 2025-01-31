class_name NPCCharacter extends Node2D

@onready var bubble_slot : Node2D = $BubbleSlot

@export var base_sprite: Sprite2D
@export var highlight_sprite: Sprite2D

@export var game_status : String
@export var use_state_manager : bool = false

@export var npc_state : String = "Default"

@export var state_mapping : Dictionary

@export var move_position : int = 0

func _ready() -> void:
	SignalBus.connect("on_state_changed", _resolve_state_change)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name != "PlayerCharacter":
		return
	toggle_sprite_highlight()
	
	await get_tree().process_frame
	bubble_slot.start_dialog()
	body._get_active_npc_bubble(self)
	GameManager.open_swap_ui()


func _on_area_2d_body_exited(body: Node2D) -> void:
	print("npc exited")
	if body.name != "PlayerCharacter":
		return
	toggle_sprite_highlight()
	bubble_slot._end_dialog()
	body._exit_npc_cleanup(self)
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
	if new_state == npc_state:
		return
	npc_state = new_state
	if !emit.is_empty():
		_resolve_new_state(emit)
	#else:
		#print("NPC ["+self.name+"] state not found: "+npc_state)

func _resolve_new_state(emit : String):
	if emit == "advance_dialog":
		bubble_slot.advance_dialog()
		return
	if emit == "cycle_dialog":
		bubble_slot.cycle_dialog()
		return
	
	SignalBus.on_move_command.emit(emit, self.name)	
	SignalBus.on_state_changed.emit(emit, self.name)
	
func _resolve_state_change(check_value : String, npc_name : String):
	if self.name != npc_name:
		LevelStateManager.resolve_npc_state(self, check_value)

func flip_sprites():
	base_sprite.flip_h = !base_sprite.flip_h
	highlight_sprite.flip_h = !highlight_sprite.flip_h
