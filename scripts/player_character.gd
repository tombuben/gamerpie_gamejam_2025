extends CharacterBody2D

@onready var bubble_slot : Node2D = $BubbleSlot
@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var audio = $AudioStreamPlayer2D

@onready var bubble_ico_scene = preload("res://ui/bubble ico/bubble_ico.tscn")

@export var player_speed = 200
@export var friction = 0.3
@export var acceleration = 0.1

var npc_parents = []

var bubble_ico
var bubble_ico_active = false

var last_played_position : Vector2
@export var sound_every_x_pixels : float = 65

#var pause_menu

func _ready():
	GameManager.Player = self
	sprite.play("default")

func get_input():
	var input = Vector2()
	if Input.is_action_pressed('right'):
		input.x += 1
	if Input.is_action_pressed('left'):
		input.x -= 1
	if Input.is_action_pressed('down'):
		input.y += 1
	if Input.is_action_pressed('up'):
		input.y -= 1
	return input

func _physics_process(_delta):
	var direction = get_input()
	if direction.length() > 0:
		velocity = velocity.lerp(direction.normalized() * player_speed, acceleration)
	else:
		velocity = velocity.lerp(Vector2.ZERO, friction)
	
	sprite.flip_h = velocity.x < 0
	
	var animation_speed = velocity.length() / 25
	sprite.speed_scale = animation_speed
	if animation_speed < 0.05:
		sprite.set_frame_and_progress(0, 0.0)
		last_played_position = global_position
		
	move_and_slide()
	
	var step = last_played_position.distance_to(global_position)
	if step > sound_every_x_pixels:
		audio.pitch_scale = randf_range(0.8, 1.2)
		audio.play()
		last_played_position = global_position
	
func _get_active_npc_bubble(parent: NPCCharacter):
	npc_parents.push_back(parent)
	var closest = get_npc_parent()
	for body in npc_parents:
		parent.set_sprite_highlight(body == closest)

func get_npc_parent():
	var min_dist = INF
	var min_obj = null
	for parent in npc_parents:
		var new_dist = global_position.distance_to(parent.global_position)
		if new_dist < min_dist:
			min_dist = new_dist
			min_obj = parent
	
	return min_obj

func _clean_npc_storage(body):
	npc_parents.erase(body)
	body.set_sprite_highlight(false)

func toggle_bubble_icon():
	if bubble_slot.bubble.checkValue == "Empty":
		#bubble_ico.queue_free()
		bubble_slot.remove_child(bubble_ico)
		bubble_ico_active = false
		return
	
	if bubble_ico_active:
		return
	
	if bubble_slot != null:
		bubble_ico = bubble_ico_scene.instantiate()
		bubble_slot.add_child(bubble_ico)
		bubble_ico_active = true

func _exit_npc_cleanup(body):
	_clean_npc_storage(body)
	GameManager.close_swap_ui()
	
	await get_tree().process_frame
	var next_closest = get_npc_parent()
	if next_closest != null:
		GameManager.open_swap_ui()
	
func _stop_all_dialogs():
	get_npc_parent().bubble_slot._end_dialog()
	if bubble_slot.is_dialog_active:
		bubble_slot._end_dialog()
