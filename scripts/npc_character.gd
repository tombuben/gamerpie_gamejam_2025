class_name NPCCharacter extends Node2D

@onready var bubble_slot : Node2D = $BubbleSlot

@export var base_sprite: Sprite2D
@export var highlight_sprite: Sprite2D

@export var game_status : String
@export var use_state_manager : bool = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name != "PlayerCharacter":
		return
	toggle_sprite_highlight()
	
	#var showSwap = true;
	await get_tree().process_frame
	#bubble_slot.start_dialog(showSwap)
	bubble_slot.start_dialog()
	body._get_active_npc_bubble(self)
	body._open_swap_ui()


func _on_area_2d_body_exited(body: Node2D) -> void:
	print("npc exited")
	if body.name != "PlayerCharacter":
		return
	toggle_sprite_highlight()
	bubble_slot._end_dialog()
	body._exit_npc_cleanup(self)
	AudioDialogManager.stop_dialog_play()
		
	
func toggle_sprite_highlight():
	if base_sprite != null && highlight_sprite != null:
		base_sprite.visible = !base_sprite.visible
		highlight_sprite.visible = !highlight_sprite.visible
		

func set_sprite_highlight(highlighted):
	if base_sprite != null && highlight_sprite != null:
		base_sprite.visible = !highlighted
		highlight_sprite.visible = highlighted
