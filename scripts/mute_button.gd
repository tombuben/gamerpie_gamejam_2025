extends MarginContainer

@export var mute : RichTextLabel
@export var unmute : RichTextLabel

func _ready():
	var is_mute = is_master_bus_mute()
	
	mute.visible = !is_mute
	unmute.visible = is_mute

func toggle_mute():
	var master_bus_index = get_master_bus_index()
	AudioServer.set_bus_mute(master_bus_index, !AudioServer.is_bus_mute(master_bus_index))
	
	var is_mute = is_master_bus_mute(master_bus_index)
	
	mute.visible = !is_mute
	unmute.visible = is_mute

func get_master_bus_index():
	return AudioServer.get_bus_index("Master")
	
func is_master_bus_mute(master_bus_index = null):
	if master_bus_index:
		return AudioServer.is_bus_mute(master_bus_index);
		
	return AudioServer.is_bus_mute(get_master_bus_index());
