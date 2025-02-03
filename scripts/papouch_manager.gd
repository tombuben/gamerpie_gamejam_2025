extends Node2D

@export var swap_time : float

@export var Player : Node2D

@export var P1 : Node2D
@export var P2 : Node2D
@export var P3 : Node2D
@export var P4 : Node2D

var parrot_nodes : Array[Node2D]

var time = 0

func _ready():
	
	parrot_nodes.append(P1)
	parrot_nodes.append(P2)
	parrot_nodes.append(P3)
	parrot_nodes.append(P4)	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
		
	time += delta
	
	if time > swap_time:
		time = 0
		swap_papouch()

func swap_papouch():
	
	P1.bubble_slot._end_dialog()
	P2.bubble_slot._end_dialog()	
	
	P1.set_sprite_highlight(false)
	P2.set_sprite_highlight(false)
	
	var parrot_bubbles : Array[Node2D]
	var bubble_parents : Array[Node2D]
	
	for node in parrot_nodes:
		var bubble = node.bubble_slot.bubble
		parrot_bubbles.append(bubble)
		bubble_parents.append(bubble.get_parent())
	
	for i in range(4):
		bubble_parents[i].remove_child(parrot_bubbles[i])
		
	for i in range(4):
		var j = i+1
		if j > 3:
			j = 0
		parrot_nodes[i].bubble_slot.add_child(parrot_bubbles[j])
		parrot_nodes[i].bubble_slot.bubble = parrot_bubbles[j]
		parrot_nodes[i].player_exited()
		parrot_nodes[i].player_entered()

#leaving here for easier potential reroll to old system
func swap_papouch_old():
	
	P1.bubble_slot._end_dialog()
	P2.bubble_slot._end_dialog()
	P3.bubble_slot._end_dialog()
	P4.bubble_slot._end_dialog()	
	
	P1.set_sprite_highlight(false)
	P2.set_sprite_highlight(false)
	P3.set_sprite_highlight(false)
	P4.set_sprite_highlight(false)
	
	var P_pos = P4.global_position
	P4.global_position = P3.global_position
	P3.global_position = P2.global_position
	P2.global_position = P1.global_position
	P1.global_position = P_pos
	
	P1.flip_sprites()
	P2.flip_sprites()
	P3.flip_sprites()
	P4.flip_sprites()
