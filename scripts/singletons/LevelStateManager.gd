extends Node

var base_path = "res://levels/LevelStates/"

var NpcStateResolverDict : Dictionary

@export var check_subscribers : Dictionary

func load_level_states():
	NpcStateResolverDict = load_json()

func populate_check_subscribers():
	var level = "Level" + String.num_int64(GameManager.current_level)
	
	if NpcStateResolverDict.has(level) == false:
		print("Level " + level + " not found in state resolver")
		return
	
	var check_values_array : Array[String]
	
	for npc in NpcStateResolverDict[level]:
		var checks = NpcStateResolverDict[level][npc].keys()
		for check in checks:
			if !check_values_array.has(check):
				check_values_array.append(check)
	
	for check in check_values_array:
		var subscribe_npcs : Array[String]
		for npc in NpcStateResolverDict[level]:
			if NpcStateResolverDict[level][npc].keys().has(check):
				subscribe_npcs.append(npc)
		
		check_subscribers[check] = subscribe_npcs

func resolve_npc_state(npc : Node2D, check_value : String) -> void:	
	print("Resolving state for " + npc.name)
	var npc_name = npc.name
	var current_state = npc.npc_state
	var new_state : String
	var emit : String
	var wait : float = 0
	var level = "Level" + String.num_int64(GameManager.current_level)
	if NpcStateResolverDict.has(level) == false:
		print("Level " + level + " not found in state resolver")
		return
		
	if NpcStateResolverDict[level].has(npc_name) == false:
		print("Npc name not found in state resolver")
		return
	
	var npc_states_dict = NpcStateResolverDict[level][npc_name]
	
	var state_changes
	if npc_states_dict.has(check_value) == false:
		return
	else:
		state_changes = npc_states_dict[check_value]
		
	if state_changes.has(current_state):
		new_state = state_changes[current_state]["NextState"]
		
		if state_changes[current_state].has("Emit"):
			emit = state_changes[current_state]["Emit"]
		
		if state_changes[current_state].has("Wait"):
			wait = state_changes[current_state]["Wait"]
	else:
		return
	
	await get_tree().create_timer(wait).timeout
	npc.apply_new_state(new_state, emit)
	
func load_json() -> Dictionary:
	var file_path = base_path + "Level_" + String.num_int64(GameManager.current_level) + ".json"
	# Check if the file exists
	if not FileAccess.file_exists(file_path):
		print("File does not exist: ", file_path)
		return {"Level": []}

	# Open the file for reading
	var file = FileAccess.open(file_path, FileAccess.READ)
	if not file:
		print("Failed to open file: ", file_path)
		return {"Level": []}

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
