extends Node2D

@export var collider : CollisionShape2D

@export var base_sprite: Sprite2D
@export var highlight_sprite: Sprite2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name != "PlayerCharacter":
		return
	
	if GameManager.player_has_bubble:
		toggle_sprite_highlight()

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name != "PlayerCharacter":
		return
	
	if GameManager.player_has_bubble:
		toggle_sprite_highlight()
		
func toggle_sprite_highlight():
	if base_sprite != null && highlight_sprite != null:
		base_sprite.visible = !base_sprite.visible
		highlight_sprite.visible = !highlight_sprite.visible
