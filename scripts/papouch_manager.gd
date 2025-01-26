extends Node2D

@export var swap_time : float

@export var Player : Node2D

@export var P1 : Node2D
@export var P2 : Node2D
@export var P3 : Node2D
@export var P4 : Node2D

var time = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
		
	time += delta
	
	if time > swap_time:
		time = 0
		swap_papouch()
		
func swap_papouch():
	
	P1.bubble_slot._end_dialog()
	P2.bubble_slot._end_dialog()
	P3.bubble_slot._end_dialog()
	P4.bubble_slot._end_dialog()
	
	var P_pos = P4.global_position
	P4.global_position = P3.global_position
	P3.global_position = P2.global_position
	P2.global_position = P1.global_position
	P1.global_position = P_pos
