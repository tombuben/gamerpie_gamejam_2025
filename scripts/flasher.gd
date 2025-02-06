extends Node2D

@export var f1 : Control
@export var f2 : Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	f1.visible = true
	f2.visible = false
	while true:
		await get_tree().create_timer(0.5).timeout
		f1.visible = !f1.visible
		f2.visible = !f2.visible



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
