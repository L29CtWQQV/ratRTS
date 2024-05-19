extends Node
@onready var navag = $"../NavigationAgent3D"
@onready var target = $"../gl/target" 
@onready var rat = $".."
var move_object = null
var fighting = false
var follow_action = null
var last_attack = 0
var started_moving = false
var o_rats = []

func _ready():
	follow_action = rat.idle

func set_target(p:Vector3,list:Node):
	o_rats = list
	var op = p
	navag.target_position = p
	if !navag.is_target_reachable():
		return false

	var overlap = true
	var s = 1.5
	var cnt = 0
	while overlap:
		cnt += 1
		if cnt > 12:
		#	print("to crowded")
			return true #give up
		p=op + Vector3(randf_range(-s,s),0.0,randf_range(-s,s))
		target.global_position=p
		navag.target_position = p
		overlap = false
		for c in list.get_children() :
			if ((c!= rat) and (target.global_position-c.target.global_position).length()<.4):
				overlap = true
		if !navag.is_target_reachable():
			overlap = true
		#if move_object != null and (move_object.global_position - rat.global_position).length()>1.5:
		#	overlap = true
		s+= .4
	return true

func stop_action():
	if !fighting and move_object != null:
		if started_moving:
			move_object.remove_mover()
			started_moving = false
		move_object = null

func act(rat: Node3D,delta):
	if fighting:
		last_attack += delta
		if last_attack > 1.8:
			if (move_object.global_position-rat.global_position).length()<.5:
				move_object.kill()
				rat.action = follow_action
	if rat.allow_movement:
		rat.global_position  = rat.global_position.move_toward(navag.get_next_path_position(),delta*rat.speed)
	else:
			#rat.global_position  +=rat.global_position - rat.global_position.move_toward(navag.get_next_path_position(),delta*rat.speed)
		var s = .3
		rat.global_position += Vector3(randf_range(-s,s),0,randf_range(-s,s))
			
	if rat.global_position == navag.get_final_position():

		if move_object == null or move_object.finished:
			stop_action()
			rat.action=follow_action
		else:
			if !fighting and !started_moving:
				started_moving = true
				move_object.add_mover()
			set_target(move_object.global_position,o_rats)

func _process(delta):
	pass
