extends Node2D

@onready var bubble : Node2D = $Bubble

func _bubble_slot_changed():
	print("bubble slot changed")
