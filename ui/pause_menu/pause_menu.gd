extends Control

@onready var resume : MarginContainer = $Resume
@onready var restart : MarginContainer = $Restart
@onready var mute : MarginContainer = $Mute

@export var objective : RichTextLabel

var buttons: Array[MarginContainer]

var select_index = 0

var objectives = {
	"Level1":"Escape from prison.",
	"Level2":"Find out where the rich guy put his money.",
	"Level3":"Get the clerk to withdraw Piratessons money."
}

func open_menu():
	get_tree().paused = true
	buttons = [
		resume,
		restart,
		mute
	]
	var root = get_tree().root
	
	if root.get_node("Level1"):
		objective.text = objectives["Level1"]
		return
	if root.get_node("Level2"):
		objective.text = objectives["Level2"]
		return
	if root.get_node("Level3"):
		objective.text = objectives["Level3"]
		return
	

func _input(event):
	if event is InputEventKey:
		if event.is_action_pressed('left'):
			move_select_left()
			set_select()
		if event.is_action_pressed('right'):
			move_select_right()
			set_select()
		if event.is_action_pressed('bubble_switch'):
			if buttons[0] != null:
				process_button_select()
		

func move_select_left():
	if select_index > 0:
			select_index -= 1
			
func move_select_right():
	if select_index < buttons.size() -1:
			select_index += 1
			
func set_select():
	for button in buttons:
		button.get_node("Select").visible = false
	
	buttons[select_index].get_node("Select").visible = true

func process_button_select():
	var selected_button = buttons[select_index]
	
	match selected_button.name:
		"Resume":
			Resume()
		"Restart":
			Restart()
		"Mute":
			Mute()
	
func Resume():
	#UNPAUSE PLAYER AND KILL THIS MENU
	get_tree().paused = false
	close_menu()
	return
	
func Restart():
	#RESTART LEVEL AND KILL THIS MENU
	get_tree().paused = false
	get_tree().reload_current_scene()
	return
	
func Mute():
	#var bg_music = get_tree().get_root().get_node("BG-music")
	#var dialogue_player = get_tree().get_root().get_node("DialoguePlayer")
	
	var master_bus_index = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_mute(master_bus_index, !AudioServer.is_bus_mute(master_bus_index))
	return
	
func close_menu():
	#KILLS THIS MENU
	queue_free()
	return
