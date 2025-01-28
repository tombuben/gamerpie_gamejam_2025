extends Area2D

@export var scene: PackedScene

func _on_body_entered(body: Node2D) -> void:
	if body.name != "PlayerCharacter":
		return
	
	get_tree().change_scene_to_packed(scene)
	DialogManager.next_level()
