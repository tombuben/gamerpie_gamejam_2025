extends Node

var audio_player : AudioStreamPlayer2D


var base_path = "res://assets/audio/dialogue/"

var audio_dict = {
	"Come here, you rat!":"lvl1_ComeHereYouRat.mp3",
	"You are never getting out of here!":"lvl1_NeverGettingOut.mp3",
	"Squeek!":"lvl1_Squeek.mp3"
}

func play_dialogue_audio(line : String):
	if !audio_dict.has(line) || audio_player == null:
		return
	
	var file_name = audio_dict[line]
	var file_path = base_path + file_name
	
	var stream = load(file_path)
	if stream is AudioStream:
		audio_player.stream = stream
		audio_player.play()
	else:
		print("Failed to load audio file")
