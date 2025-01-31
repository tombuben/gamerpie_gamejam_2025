extends Node

@export var level_index : int

@export var scene : PackedScene

func _enter_tree():
	GameManager.new_level_init(level_index)
	print("level init sent")
	
func _ready() -> void:
	SignalBus.connect("on_state_changed", _resolve_state_change)

func _resolve_state_change(check_value : String, npc_name : String):
	if check_value == "ObjectiveAchieved":
		await get_tree().create_timer(3.0).timeout
		get_tree().change_scene_to_packed(scene)
