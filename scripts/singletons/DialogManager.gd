extends Node

var current_level : int

var base_path = "res://assets/text/dialogues/"

var level_dialog_dict : Dictionary
var dialog_lines_dict : Dictionary
var line_audio_dict : Dictionary

func _ready():
	var level_name = String(get_tree().root.get_child(2).name)
	current_level = level_name.substr(level_name.length() - 1).to_int()
	level_dialog_dict = load_json(current_level)
	map_dialog_lines()
	map_dialog_audio()

func get_dialog_line(dialog_id : int, line_index : int):
	var dialog_lines = get_lines_dict_by_id(dialog_id)
	return dialog_lines[line_index]["line"]

func get_lines_dict_by_id(dialog_id : int):
	return dialog_lines_dict[dialog_id]
	
func get_lines_array_by_id(dialog_id : int):
	var lines_array : Array[String]
	
	for line in dialog_lines_dict[dialog_id]:
		lines_array.append(line["line"])
		
	return lines_array

func map_dialog_audio():
	for character in level_dialog_dict["characters"]:
		for line in character["lines"]:
			if !line.has("filename"):
				continue
			line_audio_dict[line["line"]] = line["filename"]

func map_dialog_lines():
	for character in level_dialog_dict["characters"]:
		var test = character["id"]
		dialog_lines_dict[int(character["id"])] = character["lines"]		

func load_json(curent_level : int) -> Dictionary:
	var file_path = base_path + "level_" + String.num_int64(current_level) + ".json"
	# Check if the file exists
	if not FileAccess.file_exists(file_path):
		print("File does not exist: ", file_path)
		return {}

	# Open the file for reading
	var file = FileAccess.open(file_path, FileAccess.READ)
	if not file:
		print("Failed to open file: ", file_path)
		return {}

	# Read the contents of the file as text
	var json_string = file.get_as_text()
	file.close()

	# Parse the JSON string
	var json = JSON.new()
	var result = json.parse(json_string)

	# Check if parsing was successful
	if result != OK:
		print("JSON Parse Error: ", json.get_error_message(), " at line ", json.get_error_line())
		return {}

	# Return the parsed data as a dictionary
	return json.data
