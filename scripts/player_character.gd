extends CharacterBody2D

@onready var bubble_slot : Node2D = $PlayerBubbleSlot

@export var player_speed = 200
@export var friction = 0.01
@export var acceleration = 0.1

@export var npc_bubble = null

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
	
func _get_active_npc_bubble(bubble: Node2D):
	npc_bubble = bubble
	print("npc bubble got")
	print(npc_bubble.name)
	print(npc_bubble.checkValue)
	if npc_bubble != null:
		print("npc bubble saved")
	else:
		print("npc bubble not saved")
	
	
func _process(delta):
	if Input.is_action_just_pressed('bubble_switch'):
		print("bubble_switch")
		_bubble_switch()

func _bubble_switch():
	if npc_bubble != null:
		print(npc_bubble.lines[0])
		$PlayerBubbleSlot.bubble_line = npc_bubble.lines[0]
		print($PlayerBubbleSlot.bubble_line)
	else:
		print("npc bubble empty")
	
