extends CharacterBody2D

@onready var bubble_slot : Node2D = $BubbleSlot
@onready var sprite : Sprite2D = $Sprite2D

#@onready var swap_box_scene = preload("res://ui/swap box/swap_box.tscn")
@onready var swap_box_scene = preload("res://ui/swap box v2/swap_box_v2.tscn")
@onready var bubble_ico_scene = preload("res://ui/bubble ico/bubble_ico.tscn")
@onready var pause_menu_scene = preload("res://ui/pause_menu/pause_menu.tscn")

@export var player_speed = 200
@export var friction = 0.01
@export var acceleration = 0.1

var npc_parents = []

var input_timeout = 0

func get_npc_parent():
	var min_dist = INF
	var min_obj = null
	for parent in npc_parents:
		var new_dist = global_position.distance_to(parent.global_position)
		if new_dist < min_dist:
			min_dist = new_dist
			min_obj = parent
	
	return min_obj

var swap_box
var swap_active = null

var bubble_ico
var bubble_ico_active = false

var pause_menu

func get_input():
	var input = Vector2()
	if Input.is_action_pressed('right'):
		input.x += 1
	if Input.is_action_pressed('left'):
		input.x -= 1
	if Input.is_action_pressed('down'):
		input.y += 1
	if Input.is_action_pressed('up'):
		input.y -= 1
	return input

func _physics_process(_delta):
	var direction = get_input()
	if direction.length() > 0:
		velocity = velocity.lerp(direction.normalized() * player_speed, acceleration)
	else:
		velocity = velocity.lerp(Vector2.ZERO, friction)
	
	sprite.flip_h = velocity.x < 0
	
	move_and_slide()
	
func _get_active_npc_bubble(parent: NPCCharacter):
	npc_parents.push_back(parent)
	var closest = get_npc_parent()
	for body in npc_parents:
		parent.set_sprite_highlight(body == closest)
	
func _process(delta):
	if input_timeout > 0:
		input_timeout -= 1
	if Input.is_action_just_pressed('bubble_switch'):
		print("bubble_switch")
		if len(npc_parents) == 0 && input_timeout <= 0:
			input_timeout = 5
			pause_menu = pause_menu_scene.instantiate()
			get_tree().root.add_child(pause_menu)
			pause_menu.open_menu()
			return
		if swap_active != null:
			_bubble_switch()
			return

func _bubble_switch():
	var my_bubble_slot = bubble_slot
	var closest_npc = get_npc_parent()
	var other_bubble_slot = closest_npc.bubble_slot
	var npc_bubble = other_bubble_slot.bubble
	var player_bubble = bubble_slot.bubble
	
	my_bubble_slot.remove_child(player_bubble)
	other_bubble_slot.remove_child(npc_bubble)
	
	my_bubble_slot.add_child(npc_bubble)
	other_bubble_slot.add_child(player_bubble)
	my_bubble_slot.bubble = npc_bubble
	other_bubble_slot.bubble = player_bubble

	bubble_slot.on_slot_changed.emit(npc_bubble.checkValue)
	#my_bubble_slot.start_dialog()
	toggle_bubble_icon()
	closest_npc.bubble_slot._bubble_slot_changed(closest_npc.bubble_slot.bubble.checkValue)
	
	other_bubble_slot = closest_npc.bubble_slot
	other_bubble_slot._bubble_slot_changed(other_bubble_slot.bubble.checkValue)
	
	_clean_npc_storage(closest_npc)
	_close_swap_ui()
	
func _clean_npc_storage(body):
	npc_parents.erase(body)
	body.set_sprite_highlight(false)

func toggle_bubble_icon():
	if bubble_slot.bubble.checkValue == "empty":
		#bubble_ico.queue_free()
		bubble_slot.remove_child(bubble_ico)
		bubble_ico_active = false
		return
	
	if bubble_ico_active:
		return
	
	if bubble_slot != null:
		bubble_ico = bubble_ico_scene.instantiate()
		bubble_slot.add_child(bubble_ico)
		bubble_ico_active = true
	
func _open_swap_ui():
	if swap_active != null:
		swap_active.set_sprite_highlight(false)
		swap_box.queue_free()
	
	var closest = get_npc_parent()
	if closest == null:
		return
	closest.set_sprite_highlight(true)
	var npc_text = closest.bubble_slot._get_current_line()
	var player_text = bubble_slot._get_current_line()
	swap_box = swap_box_scene.instantiate()
	get_tree().root.add_child(swap_box)
	swap_box.display_text(npc_text, player_text)
	swap_active = get_npc_parent()
	#_stop_all_dialogs()

func _exit_npc_cleanup(body):
	_clean_npc_storage(body)
	_close_swap_ui()
	
	await get_tree().process_frame
	var next_closest = get_npc_parent()
	if next_closest != null:
		_open_swap_ui()
	
func _close_swap_ui():
	if swap_active != null:
		swap_box.queue_free()
		swap_active = null
		
func _stop_all_dialogs():
	get_npc_parent().bubble_slot._end_dialog()
	if bubble_slot.is_dialog_active:
		bubble_slot._end_dialog()
