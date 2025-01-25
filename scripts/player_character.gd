extends CharacterBody2D

@onready var bubble_slot : Node2D = $BubbleSlot

@export var player_speed = 200
@export var friction = 0.01
@export var acceleration = 0.1

@export var npc_parent = null
@export var npc_bubble_slot = null

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
	move_and_slide()
	
func _get_active_npc_bubble(parent: Node2D, bubble_slot: Node2D):
	npc_parent = parent
	npc_bubble_slot = bubble_slot
	if npc_bubble_slot != null:
		print("npc bubble slot saved")
	else:
		print("npc bubble slot not saved")
	
	
func _process(delta):
	if Input.is_action_just_pressed('bubble_switch'):
		print("bubble_switch")
		_bubble_switch()

func _bubble_switch():
	var my_bubble_slot = bubble_slot
	var other_bubble_slot = npc_bubble_slot
	var npc_bubble = npc_bubble_slot.bubble
	var player_bubble = bubble_slot.bubble
	
	my_bubble_slot.remove_child(player_bubble)
	other_bubble_slot.remove_child(npc_bubble)
	
	my_bubble_slot.add_child(npc_bubble)
	other_bubble_slot.add_child(player_bubble)
	other_bubble_slot.bubble = player_bubble
		
	my_bubble_slot.start_dialog()
	npc_bubble_slot._bubble_slot_changed(npc_bubble_slot.bubble.checkValue)
