class_name BubbleSlot extends Node2D

@onready var text_box_scene = preload("res://ui/text box/text_box.tscn")

signal on_slot_changed(check_value : String)

@onready var bubble : Node2D = $Bubble

var dialog_line: String

var text_box
var text_box_position: Vector2
var bubble_slot: Node2D

var line_index = 0

var is_dialog_active = false

func start_dialog():	
	var parent = get_parent()
	bubble = $Bubble
	if is_dialog_active && parent.name == "PlayerCharacter":
		_end_dialog()
	elif is_dialog_active:
		return
	bubble_slot = self
	print(bubble.lines)
	dialog_line = bubble.lines[line_index]
	text_box_position = global_position
	_show_text_box()
	
	is_dialog_active = true
	

func _show_text_box():
	text_box = text_box_scene.instantiate()
	bubble_slot.add_child(text_box)
	text_box.global_position = text_box_position
	text_box.display_text(dialog_line)
	

func _end_dialog():
	text_box.queue_free()
	is_dialog_active = false
	return


func _bubble_slot_changed(check_value : String):
	on_slot_changed.emit(check_value)
	print("bubble slot changed")
	_end_dialog()
	start_dialog()

func _advance_dialog():
	print(bubble.lines)
	if line_index + 1 <= len(bubble.lines) - 1:
		line_index += 1;
		
		if is_dialog_active:
			_end_dialog()
			start_dialog()

func _on_level_2_advance_bubble() -> void:
	_advance_dialog()
