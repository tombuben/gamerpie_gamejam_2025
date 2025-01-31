extends Node

@onready var swap_box_scene = preload("res://ui/swap box v2/swap_box_v2.tscn")
@onready var pause_menu_scene = preload("res://ui/pause_menu/pause_menu.tscn")

var Player : CharacterBody2D

var levels : Array[String] = ["1","2","3"]
var current_level : int
var init_level : int

var input_timeout = 0

var swap_target = null
var swap_box

var pause_menu

func _ready():
	return

func new_level_init(level_index : int):
	print("scene init")
	init_level = level_index
	load_current_level()
	
func _process(delta):
	if input_timeout > 0:
		input_timeout -= 1
	if Input.is_action_just_pressed('bubble_switch'):
		print("bubble_switch")
		_spacebar_pressed()

func load_current_level():
	if init_level == current_level:
		return
	
	current_level = init_level	
	Player = null
	DialogManager.load_level_dialogs()

func _spacebar_pressed():	
	if Player != null && len(Player.npc_parents) == 0 && input_timeout <= 0:
		open_pause_menu()
		return
	if swap_target != null:
		_bubble_switch()

func open_pause_menu():
	input_timeout = 5
	pause_menu = pause_menu_scene.instantiate()
	get_tree().root.add_child(pause_menu)
	pause_menu.open_menu()
	
func _bubble_switch():	
	var player_bubble_slot = Player.bubble_slot
	var closest_npc = Player.get_npc_parent()
	var other_bubble_slot = closest_npc.bubble_slot
	var npc_bubble = other_bubble_slot.bubble
	var player_bubble = Player.bubble_slot.bubble
	
	player_bubble_slot.remove_child(player_bubble)
	other_bubble_slot.remove_child(npc_bubble)
	
	player_bubble_slot.add_child(npc_bubble)
	other_bubble_slot.add_child(player_bubble)
	
	player_bubble_slot.bubble = npc_bubble
	other_bubble_slot.bubble = player_bubble

	Player.bubble_slot.on_slot_changed.emit(npc_bubble.checkValue)
	#my_bubble_slot.start_dialog()
	Player.toggle_bubble_icon()
	closest_npc.bubble_slot._bubble_slot_changed(closest_npc.bubble_slot.bubble.checkValue)
	
	other_bubble_slot = closest_npc.bubble_slot
	other_bubble_slot._bubble_slot_changed(other_bubble_slot.bubble.checkValue)
	
	close_swap_ui()
	open_swap_ui()

func open_swap_ui():	
	if swap_target != null:
		swap_target.set_sprite_highlight(false)
		swap_box.queue_free()
	
	var closest = Player.get_npc_parent()
	if closest == null:
		return
	closest.set_sprite_highlight(true)
	var npc_text = closest.bubble_slot._get_current_line()
	var player_text = Player.bubble_slot._get_current_line()
	swap_box = swap_box_scene.instantiate()
	get_tree().root.add_child(swap_box)
	swap_box.display_text(npc_text, player_text)
	swap_target = Player.get_npc_parent()
	#_stop_all_dialogs()
	
func close_swap_ui():
	if swap_target != null:
		swap_box.queue_free()
		swap_target = null

func next_level():
	load_current_level()

func _load_player(node : CharacterBody2D):
	if Player == null:
		Player = node
