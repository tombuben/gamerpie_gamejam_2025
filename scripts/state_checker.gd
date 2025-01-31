extends Node2D

signal advance_bubble

@export var level21 : Dictionary
@export var level22 : Dictionary
@export var level23 : Dictionary

@export var num_of_states : int
@export var scene : PackedScene

@onready var player = $PlayerCharacter

var states
var current_state_num : int = 0

@export var level_index : int

func _enter_tree():
	GameManager.new_level_init(level_index)
	print("level init sent")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	level21 = convert_node_path_keys(level21)
	level22 = convert_node_path_keys(level22)
	level23 = convert_node_path_keys(level23)
	states = [level21, level22, level23]
	SignalBus.connect("on_state_changed", _resolve_state_change)


func convert_node_path_keys(dict : Dictionary):
	var ret_dict : Dictionary = {}
	for key in dict:
		if key is NodePath:
			var obj = get_node(key)
			ret_dict[obj] = dict[key]
		else:
			ret_dict[key] = dict[key]
	
	return ret_dict

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_bubble_slot_on_slot_changed(check_value: String) -> void:
	check_current_state()
	pass # Replace with function body.
	

func check_current_state():
	if (current_state_num >= num_of_states):
		return
	var current_state = states[current_state_num]
	var valid : bool = true;
	for key in current_state:
		var node = key
		var bubble = node.bubble
		var value = bubble.checkValue
		if value != current_state[key]:
			valid = false;
			
	if valid:
		current_state_num += 1
		# should lock all swapping for a sec, play a jingle
		await get_tree().create_timer(2.5).timeout
		advance_state()

func advance_state():
	advance_bubble.emit()
	
	if GameManager.swap_target != null:
		GameManager.close_swap_ui()
		await get_tree().process_frame
		GameManager.open_swap_ui()
	
	if (current_state_num >= num_of_states):
		await get_tree().create_timer(3.0).timeout
		get_tree().change_scene_to_packed(scene)
		#GameManager.next_level()
		#DialogManager.next_level()
		
func _resolve_state_change(check_value : String, npc_name : String):
	if check_value == "ObjectiveAchieved":
		await get_tree().create_timer(3.0).timeout
		get_tree().change_scene_to_packed(scene)
