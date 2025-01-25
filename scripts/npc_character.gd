extends Node2D

@onready var bubble_slot : Node2D = $BubbleSlot

@export var base_sprite: Sprite2D
@export var highlight_sprite: Sprite2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name != "PlayerCharacter":
		return
	toggle_sprite_highlight()
	var showSwap = true;
	bubble_slot.start_dialog(showSwap)
	body._get_active_npc_bubble(self, bubble_slot)


func _on_area_2d_body_exited(body: Node2D) -> void:
	print("npc exited")
	if body.name != "PlayerCharacter":
		return
	toggle_sprite_highlight()
	body._clean_npc_storage()
	bubble_slot._end_dialog()
	body.swap_box.queue_free()
		
	
func toggle_sprite_highlight():
	if base_sprite != null && highlight_sprite != null:
		base_sprite.visible = !base_sprite.visible
		highlight_sprite.visible = !highlight_sprite.visible
