extends Node2D

@export var collider : CollisionShape2D
@export var open_when : String


@export var starts_open : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if starts_open:
		open_door()
	
func close_door() -> void:
	visible = true
	collider.set_deferred("disabled", false)
	
func open_door() -> void:
	visible = false
	collider.set_deferred("disabled",true)


func _on_bubble_slot_on_slot_changed(check_value: String) -> void:
	if (check_value == open_when):
		open_door()
	else:
		close_door()
