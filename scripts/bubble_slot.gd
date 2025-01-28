extends Node2D

signal on_slot_changed(parent : Node2D, check_value : String)

@onready var bubble : Node2D = $Bubble

func _bubble_slot_changed(check_value : String):
	on_slot_changed.emit(get_parent(), check_value)
	print("bubble slot changed")
