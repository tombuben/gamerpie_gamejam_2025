extends Node2D

@export var scene : PackedScene

func _input(event: InputEvent) -> void:	
	if event.is_action_pressed("bubble_switch"):
		get_tree().change_scene_to_packed(scene)
