extends Node2D

@onready var bubble_slot : Node2D = $BubbleSlot

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name != "PlayerCharacter":
		return
	bubble_slot.start_dialog()
	body._get_active_npc_bubble(self, bubble_slot)


func _on_area_2d_body_exited(body: Node2D) -> void:
	print("npc exited")
	if body.name != "PlayerCharacter":
		return
	body._clean_npc_storage()
	bubble_slot._end_dialog()
	
