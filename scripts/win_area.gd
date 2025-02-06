extends Area2D

@export var scene: PackedScene

func _on_body_entered(body: Node2D) -> void:
	if body.name != "PlayerCharacter":
		return
	
	get_tree().call_deferred("change_scene_to_packed", scene)
	GameManager.next_level()
