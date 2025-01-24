extends Node2D

bubble_slot : Node2D = $BubbleSlot

signal npc_triggered

func _on_area_2d_body_entered(body: Node2D) -> void:
	emit_signal("npc_triggered")
	print("npc triggered")
