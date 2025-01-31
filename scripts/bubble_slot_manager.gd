class_name BubbleSlot extends Node2D

@onready var text_box_scene = preload("res://ui/text box/text_box.tscn")

signal on_slot_changed(check_value : String)

@onready var bubble : Node2D = $Bubble

@export var lines: Array[String]

@export var bubbles_dict : Dictionary

var dialog_line: String

var text_box
var text_box_position: Vector2
var bubble_slot: Node2D

var line_index = 0

var is_dialog_active = false

func _ready():
	bubbles_dict = DialogManager.get_bubbles_dict_by_id(bubble.bubble_id)
	for key in bubbles_dict:
		lines.append(key)
	fill_bubble(lines[0])
	bubble_slot = self

func start_dialog(showSwap: bool = false):	
	var parent = get_parent() 
	bubble = $Bubble
	if is_dialog_active && parent.name == "PlayerCharacter":
		_end_dialog()
	elif is_dialog_active:
		return
	bubble_slot = self
	print(bubble_slot.lines)
	dialog_line = bubble.line
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
	return bubble.line

#func _bubble_slot_changed(check_value : String):
	#on_slot_changed.emit(check_value)
	#print("bubble slot changed")
	#_end_dialog()
	#start_dialog()
	
func _bubble_slot_changed(check_value : String):
	var npc_parent = get_parent()
	print("bubble slot changed")
	if is_dialog_active:
		_end_dialog()
	start_dialog()
	LevelStateManager.resolve_npc_state(npc_parent,check_value)

func advance_dialog():
	_advance_dialog()

func _advance_dialog():	
	var old_line = bubble.line
	
	if line_index + 1 <= len(bubble_slot.lines) - 1:
		line_index += 1;
		
		var new_line = bubble_slot.lines[line_index]
		
		if old_line != new_line:
			fill_bubble(new_line)
			GameManager.close_swap_ui()
			GameManager.open_swap_ui()
			_bubble_slot_changed(bubble.checkValue)

func _on_level_2_advance_bubble() -> void:
	_advance_dialog()

func fill_bubble(line : String):
	bubble.line = line
	if bubbles_dict[line].is_empty() == false:
		bubble.checkValue = bubbles_dict[line]
