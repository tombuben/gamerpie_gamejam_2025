extends Node

var audio_player : AudioStreamPlayer2D


var base_path = "res://assets/audio/dialogue/"

var audio_dict = {
	"Come here, you rat!":"_ComeHereYouRat_FINAL.wav",
	"You are never getting out of here!":"_YouAreNever_FINAL.wav",
	"Squeek!":"_Squeek_FINAL.wav"
}

func play_dialogue_audio(line : String, npc_name : String):
	if !audio_dict.has(line) || audio_player == null:
		return
	
	var file_name = audio_dict[line]
	var file_path = base_path + npc_name + file_name
	
	var stream = load(file_path)
	if stream is AudioStream:
		audio_player.stream = stream
		audio_player.play()
	else:
		print("Failed to load audio file")
		
func stop_dialog_play():
	audio_player.stop()
