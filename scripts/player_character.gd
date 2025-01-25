extends CharacterBody2D

@onready var bubble_slot : Node2D = $PlayerBubbleSlot/Bubble

@export var player_speed = 200
@export var friction = 0.01
@export var acceleration = 0.1

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
	
func _get_active_npc_bubble(bubble_slot: Node2D):
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
	var npc_bubble = npc_bubble_slot.bubble
	if npc_bubble != null:
		print(npc_bubble.lines[0])
		var tempLine = bubble_slot.lines[0]
		var tempCheck = bubble_slot.checkValue
		bubble_slot.lines[0] = npc_bubble.lines[0]
		bubble_slot.checkValue = npc_bubble.checkValue
		npc_bubble.lines[0] = tempLine
		npc_bubble.checkValue = tempCheck
		print(bubble_slot.lines[0])
		$PlayerBubbleSlot.load_bubble(global_position)
		npc_bubble_slot._bubble_slot_changed()
	else:
		print("npc bubble empty")
	
