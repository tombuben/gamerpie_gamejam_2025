extends Node2D

@export var collider : CollisionShape2D
@export var open_when : String
@export var npc_control : Array[String]

@export var starts_open : bool = false

@onready var audio = $AudioStreamPlayer2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if starts_open:
		open_door()
		
	SignalBus.connect("on_state_changed", _on_npc_character_on_state_changed)
	
func close_door() -> void:
	visible = true
	collider.set_deferred("disabled", false)
	if audio:
		audio.play()
	
func open_door() -> void:
	visible = false
	collider.set_deferred("disabled",true)
	if audio:
		audio.play()


func _on_bubble_slot_on_slot_changed(check_value: String) -> void:
	if (check_value == open_when):
		open_door()
	else:
		close_door()

func _on_npc_character_on_state_changed(check_value : String, npc_name : String) -> void:
	if (npc_control.has(npc_name)):
		if (check_value == open_when):
			open_door()
		else:
			close_door()
