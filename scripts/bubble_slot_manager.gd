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
var active_bubble_index = 0
var uses_anchor = false

var is_dialog_active = false

func _ready():
	bubbles_dict = DialogManager.get_bubbles_dict_by_id(bubble.bubble_id)
	for key in bubbles_dict:
		lines.append(key)
	if get_child_count() > 1:
		fill_multiple_bubbles()
	else:
		fill_bubble(lines[0])
	bubble_slot = self
	
	uses_anchor = _bubble_anchor_count() > 0

func start_dialog(anchor = null):	
	var parent = get_parent() 
	#bubble = $Bubble
	if is_dialog_active && parent.name == "PlayerCharacter":
		_end_dialog()
	elif is_dialog_active:
		return
	bubble_slot = self
	#print(bubble_slot.lines)
	dialog_line = bubble.line
	text_box_position = global_position
	
	_show_text_box(anchor)
	
	#PREPARED FOR AUDIO DIALOGUES
	var npc_name = get_parent().name
	AudioDialogManager.audio_player = %DialoguePlayer
	AudioDialogManager.play_dialogue_audio_new(dialog_line, npc_name)
	
	is_dialog_active = true
	
func _show_text_box(anchor : Control):
	text_box = text_box_scene.instantiate()
	
	if _bubble_anchor_count() > 0 && anchor != null:
		anchor.add_child(text_box)
	else:
		bubble_slot.add_child(text_box)	
	
	text_box.position = Vector2.ZERO
	#print(position)
	#print(global_position)
	#print(text_box.global_position)
	text_box.display_text(dialog_line)
	
	LevelStateManager.resolve_npc_state(get_parent(), bubble.checkValue)

func _end_dialog():
	if is_dialog_active:
		text_box.queue_free()
		is_dialog_active = false
	return

func _get_current_line() -> String:
	return bubble.line
	
func _bubble_slot_changed():
	var npc_parent = get_parent()
	print("bubble slot changed")
	if is_dialog_active:
		_end_dialog()
	
	if uses_anchor:
		start_dialog(npc_parent._get_closest_bubble_slot_anchor())
	else:
		start_dialog()

func advance_dialog():
	_advance_dialog()

func _advance_dialog():	
	var old_line = bubble.line
	
	if line_index + 1 <= len(bubble_slot.lines) - 1:
		line_index += 1;
		
		var new_line = bubble_slot.lines[line_index]
		
		if old_line != new_line:
			fill_bubble(new_line)
			GameManager.reload_swap_ui()
			_bubble_slot_changed()

func _on_level_2_advance_bubble() -> void:
	_advance_dialog()

func fill_bubble(line : String):
	bubble.line = line
	if bubbles_dict[line].is_empty() == false:
		bubble.checkValue = bubbles_dict[line]

func fill_multiple_bubbles():
	for i in get_bubble_child_count():
		var child_bubble = get_child(i)
		var line = lines[i]
		
		child_bubble.line = line
		if bubbles_dict[line].is_empty() == false:
			child_bubble.checkValue = bubbles_dict[line]

func get_bubble_child_count():
	var bubble_count = 0
	for child in get_children():
		if child is Node2D:
			bubble_count += 1
	
	return bubble_count
		
func _bubble_anchor_count() -> int:
	var anchor_count = 0
	for child in get_children():
		if child is Control:
			anchor_count += 1
	
	return anchor_count
