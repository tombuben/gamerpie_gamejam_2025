extends PathFollow2D

@export var move_speed : int = 1
@export var move_when : String
@export var move_what : Node2D
@export var signal_out_trigger_npcs : Array[String]
@export var emit_message : String

func _ready() -> void:
	SignalBus.connect("on_move_command", _on_npc_character_on_move_command)

func _on_bubble_slot_on_slot_changed(check_value: String) -> void:
	if move_what != null:
		move_what.reparent(self)
		move_what.position = Vector2.ZERO
	
	if !loop:
		progress_ratio = 0
	
	var should_move = (check_value == move_when)
	var target = 0
	if should_move:
		target = 1
	var tween = get_tree().create_tween()
	tween.tween_property(self, "progress_ratio", target, 1)

func _on_npc_character_on_move_command(check_value : String, npc_name : String) -> void:
	if check_value == move_when && npc_name != self.name:
		var current_target_npc
		if move_what != null:
			move_what.reparent(self)
			move_what.position = Vector2.ZERO
			current_target_npc = move_what
		else:
			current_target_npc = get_node(npc_name)
		
		if !loop:
			progress_ratio = 0
		
		#var should_move = (check_value == move_when)
		#var target = 0
		#if should_move:
			#target = 1
		var target : int
				
		if current_target_npc.move_position == 0:
			target = 1
			current_target_npc.move_position = 1
		else:
			target = 0
			current_target_npc.move_position = 0
		
		var tween = get_tree().create_tween()
		tween.tween_property(self, "progress_ratio", target, move_speed)
		
		if signal_out_trigger_npcs.has(npc_name):
			SignalBus.on_state_changed.emit(emit_message, self.name)
