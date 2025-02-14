extends MarginContainer

@onready var timer = $LetterDisplayTimer

@export var left_notch : Control
@export var center_notch : Control
@export var right_notch : Control

@export var swap_button: Control
@export var label : RichTextLabel
@export var min_width = 100
@export var max_width = 400

@export var recenter = true

var text = ""
var letter_index = 0

var letter_time = 0.03
var space_time = 0.03
var punctuation_time = 0.2

signal finished_displaying()

func faster():
	letter_time /= 2
	space_time /= 2
	space_time /= 2
	finished_displaying.emit()

func display_text(text_to_display: String):
	text = text_to_display
	label.text = text_to_display
	label.visible_characters_behavior = TextServer.VC_CHARS_AFTER_SHAPING
	label.visible_characters = letter_index
	
	await label.resized
	label.custom_minimum_size.x = min(max(min_width, label.size.x), max_width)
	if label.size.x > max_width:
		label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		await label.resized # wait for y resize
		label.custom_minimum_size.y = size.y - 40
	
	print(global_position)
	_display_letter()
		
func _display_letter():
	
	label.visible_characters = letter_index + 1
	
	letter_index += 1
	if letter_index >= text.length():
		finished_displaying.emit()
		return
		
	match text[letter_index]:
		"!", ".", ",", "?":
			timer.start(punctuation_time)
		" ":
			timer.start(space_time)
		_:
			timer.start(letter_time)	

func set_notch(notch : int):
	if notch == -1:
		left_notch.visible = true
		center_notch.visible = false
		right_notch.visible = false
		
	if notch == 0:
		left_notch.visible = false
		center_notch.visible = true
		right_notch.visible = false
		
	if notch == 1:
		left_notch.visible = false
		center_notch.visible = false
		right_notch.visible = true

func _on_letter_display_timer_timeout() -> void:
	_display_letter()
