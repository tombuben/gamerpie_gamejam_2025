extends Node2D

@onready var text_box_scene = preload("res://ui/text box/text_box.tscn")

@onready var bubble_slot : Node2D = $Bubble

var text_box
var text_box_position: Vector2

var has_bubble = false

@export var checkValue = "Test"

func load_bubble(position: Vector2):
	if has_bubble:
		_end_dialog()
	
	text_box_position = position
	_show_text_box()
	
	has_bubble = true
	

func _show_text_box():
	text_box = text_box_scene.instantiate()
#	text_box.finished_displaying.connect(_on_text_box_finished_displaying)
	add_child(text_box)
	text_box.global_position = text_box_position
	text_box.display_text(bubble_slot.lines[0])
	

#func _on_text_box_finished_displaying():
#	can_advance_line = true
	
func _end_dialog():
	text_box.queue_free()
	has_bubble = false
	return
