extends Node

var audio_player : AudioStreamPlayer2D


var base_path = "res://assets/audio/dialogue/"

func play_dialogue_audio(line : String, npc_name : String):
	if !DialogManager.line_audio_dict.has(line) || audio_player == null:
		return
	
	var file_name = DialogManager.line_audio_dict[line]
	var file_path = base_path + npc_name + file_name
	
	var stream = load(file_path)
	if stream is AudioStream:
		audio_player.stream = stream
		audio_player.play()
	else:
		print("Failed to load audio file")
		
func play_dialogue_audio_new(line : String, npc_name : String):
	if !DialogManager.line_audio_dict.has(line) || audio_player == null:
		return
	
	var file_name = DialogManager.line_audio_dict[line]
	var file_path = base_path + npc_name + file_name
	
	var stream = load(file_path)
	if stream is AudioStream:
		audio_player.stream = stream
		audio_player.play()
	else:
		print("Failed to load audio file")
		
func stop_dialog_play():
	audio_player.stop()
