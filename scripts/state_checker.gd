extends Node2D

signal advance_bubble

@export var level21 : Dictionary
@export var level22 : Dictionary
@export var level23 : Dictionary

@export var num_of_states : int
@export var scene : PackedScene

@onready var states = [level21, level22, level23]
var current_state_num : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


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
		var node = get_node(key)
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
	
	if (current_state_num >= num_of_states):
		await get_tree().create_timer(3.0).timeout
		get_tree().change_scene_to_packed(scene)
