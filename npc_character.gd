extends Node2D

@onready var bubble_slot : Node2D = $BubbleSlot

const lines: Array[String] = [
	"This is a test dialogue."
]

signal npc_triggered

func _on_area_2d_body_entered(body: Node2D) -> void:
	emit_signal("npc_triggered")
	DialogManager.start_dialog(global_position, lines)
	print("npc triggered")
	print(name)
