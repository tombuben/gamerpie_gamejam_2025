extends Node2D

@onready var textBox = $TextBox

@export_multiline var text : String = ""
@export var scene: PackedScene
@export var button : Node2D

var can_continue : bool = false

func _ready() -> void:
	textBox.display_text(text)
	button.global_position.y += 100

func _input(event: InputEvent) -> void:
	if not can_continue:
		if event.is_action_pressed("bubble_switch"):
			textBox.faster()
		return
	
	if event.is_action_pressed("bubble_switch"):
		if scene:
			get_tree().change_scene_to_packed(scene)
		else:
			get_tree().change_scene_to_file("res://levels/start.tscn")

func _on_text_box_finished_displaying() -> void:
	can_continue = true
	button.global_position.y -= 100
	
	pass # Replace with function body.
