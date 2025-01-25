extends PathFollow2D

@export var move_when : String

func _on_bubble_slot_on_slot_changed(check_value: String) -> void:
	var should_move = (check_value == move_when)
	var target = 0
	if should_move:
		target = 1
	var tween = get_tree().create_tween()
	tween.tween_property(self, "progress_ratio", target, 1)
