extends Node2D

signal advance_bubble

@export var level21 : Dictionary
@export var level22 : Dictionary
@export var level23 : Dictionary

@onready var states = [level21, level22, level23]
var current_state : int = 0

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
	var current_state = states[current_state]
	var valid : bool = true;
	for key in current_state:
		var value = get_node(key).bubble.checkValue
		if value != current_state[key]:
			valid = false;
			
	if valid:
		# should lock all swapping for a sec, play a jingle
		await get_tree().create_timer(1.0).timeout
		advance_state()
	
func advance_state():
	current_state += 1
	advance_bubble.emit()
