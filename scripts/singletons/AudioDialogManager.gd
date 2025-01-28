extends Node

var audio_player : AudioStreamPlayer2D


var base_path = "res://assets/audio/dialogue/"

#var audio_dict = {
	#"Come here, you rat!":"_ComeHereYouRat_FINAL.wav",
	#"You are never getting out of here!":"_YouAreNever_FINAL.wav",
	#"Squeek!":"_Squeek_FINAL.wav",
	#
	#
	#"I win again!":"_IWinAgain_FINAL.mp3",
	#"Another round.":"_AnotherRound_FINAL.mp3",
	#"Do you want a drink?":"_DoYouWantADrink_FINAL.mp3",
	#"You're lying.":"_YouAreLying_FINAL.mp3",
	#"Where did you hide it?":"_WhereDidYouHideIt_FINAL.mp3",
	#"I'm so rich.":"_IAmSoRich_FINAL.mp3",
	#"I'm not telling you sober.":"_IAmNotTelling_FINAL.mp3",
	#"It's in the bank.":"_ItsInTheBank_FINAL.mp3",
	#
	#"Here's your money.":"_HeresYourMoney_FINAL.mp3",
	#"Vault number: 1234":"_VaultNumber1234_FINAL.mp3",
	#"Vault number: 4321":"_VaultNumber4321_FINAL.mp3",
	#"Vault number: 9999":"_VaultNumber9999_FINAL.mp3",
	#"Norman Person":"_NormanPerson_FINAL.mp3",
	#"News!":"_News_FINAL.mp3",
	#"Big treasure stolen!":"_BigTreasureStolen_FINAL.mp3",
	#"Suspect:":"_Suspect_FINAL.mp3",
	#"Pirate Piratesson":"_PiratePiratesson_FINAL.mp3",
#}

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
