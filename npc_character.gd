extends Node2D

@onready var bubble_slot : Node2D = $BubbleSlot

signal npc_triggered

func _on_area_2d_body_entered(body: Node2D) -> void:
	print(body.name)
	emit_signal("npc_triggered")
	DialogManager.start_dialog(global_position, $BubbleSlot.lines)
	print("npc triggered")
	print(name)
