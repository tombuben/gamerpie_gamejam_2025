extends Node2D

@onready var bubble_slot : Node2D = $BubbleSlot

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name != "PlayerCharacter":
		return
	DialogManager.start_dialog(global_position, $BubbleSlot.lines)


func _on_area_2d_body_exited(body: Node2D) -> void:
	print("npc exited")
