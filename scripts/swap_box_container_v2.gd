extends Control

@export var max_width = 400

@export var left_box : MarginContainer
@export var right_box : MarginContainer

func display_text(left_text: String, right_text: String):
	left_box.display_text(left_text)
	right_box.display_text(right_text)
