extends Node

@onready var swap_box_scene = preload("res://ui/swap box v2/swap_box_v2.tscn")
@onready var pause_menu_scene = preload("res://ui/pause_menu/pause_menu.tscn")

var Player : CharacterBody2D

var levels : Array[String] = ["1","2","3"]
var current_level : int
var init_level : int

var input_timeout = 0

var swap_ui_active = false

var swap_target = null
var swap_box

var pause_menu

func _ready():
	return

func new_level_init(level_index : int):
	print("scene init")
	init_level = level_index
	load_current_level()
	
func _process(_delta):
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
	LevelStateManager.load_level_states()
	LevelStateManager.populate_check_subscribers()

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
	
	swap_child_nodes(player_bubble_slot, player_bubble, other_bubble_slot, npc_bubble)
	
	player_bubble_slot.bubble = npc_bubble
	other_bubble_slot.bubble = player_bubble

	Player.bubble_slot.on_slot_changed.emit(npc_bubble.checkValue)
	Player.toggle_bubble_icon()
	closest_npc.bubble_slot._bubble_slot_changed()
	
	
	close_swap_ui()
	open_swap_ui()

func open_swap_ui():
	swap_ui_active = true	
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
	
func close_swap_ui():
	if swap_target != null:
		swap_box.queue_free()
		swap_target = null
		swap_ui_active = false

func reload_swap_ui():
	if swap_ui_active:
		close_swap_ui()
		open_swap_ui()

func next_level():
	load_current_level()

func swap_child_nodes(parent1, child1, parent2, child2):
	var index1 = child1.get_index()
	var index2 = child2.get_index()
	
	parent1.remove_child(child1)
	parent2.remove_child(child2)
	parent1.add_child(child2)
	parent2.add_child(child1)
	
	parent1.move_child(child2, index1)
	parent2.move_child(child1, index2)
