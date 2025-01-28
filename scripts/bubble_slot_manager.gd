class_name BubbleSlot extends Node2D

@onready var text_box_scene = preload("res://ui/text box/text_box.tscn")

signal on_slot_changed(check_value : String)

@onready var bubble : Node2D = $Bubble

var dialog_line: String

var text_box
var text_box_position: Vector2
var bubble_slot: Node2D

var line_index = 0

var is_dialog_active = false

func _ready():
	bubble.lines = DialogManager.get_lines_array_by_id(bubble.bubble_id)

func start_dialog(showSwap: bool = false):	
	var parent = get_parent()
	bubble = $Bubble
	if is_dialog_active && parent.name == "PlayerCharacter":
		_end_dialog()
	elif is_dialog_active:
		return
	bubble_slot = self
	print(bubble.lines)
	dialog_line = bubble.lines[line_index]
	text_box_position = global_position
	_show_text_box(showSwap)
	
	#PREPARED FOR AUDIO DIALOGUES
	var npc_name = get_parent().name
	AudioDialogManager.audio_player = %DialoguePlayer
	AudioDialogManager.play_dialogue_audio_new(dialog_line, npc_name)
	
	is_dialog_active = true
	

func _show_text_box(showSwap: bool):
	text_box = text_box_scene.instantiate()
	bubble_slot.add_child(text_box)
	text_box.position = Vector2.ZERO
	print(position)
	print(global_position)
	print(text_box.global_position)
	text_box.swap_button.visible = showSwap
	text_box.display_text(dialog_line)
	

func _end_dialog():
	if is_dialog_active:
		text_box.queue_free()
		is_dialog_active = false
	return

func _get_current_line() -> String:
	return bubble.lines[line_index]

func _bubble_slot_changed(check_value : String):
	on_slot_changed.emit(check_value)
	print("bubble slot changed")
	_end_dialog()
	start_dialog()

func _advance_dialog():
	
	var old_line = bubble.lines[line_index]
	
	if line_index + 1 <= len(bubble.lines) - 1:
		line_index += 1;
		
		var new_line = bubble.lines[line_index]
		
		if old_line != new_line:
			if is_dialog_active:
				_end_dialog()
			start_dialog()
			
			await get_tree().create_timer(1.0).timeout
			# todo: hide the dialog again in a while
			# if it doesn't overlap with player

func _on_level_2_advance_bubble() -> void:
	_advance_dialog()
