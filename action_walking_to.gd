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
# Called when the node enters the scene tree for the first time.
func _ready():
	follow_action = rat.idle

func set_target(p:Vector3,list:Node):
	o_rats = list
	var op = p
	navag.target_position = p
	if !navag.is_target_reachable():
		return false

	var overlap = true
	var s = .5
	var cnt = 0
	while overlap:
		cnt += 1
		if cnt > 4:
		#	print("to crowded")
			return false
		p=op + Vector3(randf_range(-s,s),0.0,randf_range(-s,s))
		target.global_position=p
		navag.target_position = p
		overlap = false
		for c in list.get_children() :
			if ((c!= rat) and (target.global_position-c.target.global_position).length()<.4)or abs(navag.get_final_position().y-p.y)>.2:
				overlap = true
				#print(c,(target.global_position-c.target.global_position).length())
		if !navag.is_target_reachable():
			overlap = true
		s+= .4
	return true

func stop_action():
	if !fighting and move_object != null:
		if started_moving:
			move_object.remove_mover()
			started_moving = false
		move_object = null

func act(rat: CharacterBody3D,delta):
	if fighting:
		last_attack += delta
		if last_attack > 1.8:
			if (move_object.global_position-rat.global_position).length()<.5:
				move_object.kill()
				rat.action = follow_action
			
	#var dir = (navag.get_next_path_position()-rat.position).normalized()*rat.speed
	rat.global_position  = rat.global_position.move_toward(navag.get_next_path_position(),delta*rat.speed)
	
	
	if rat.global_position == navag.get_final_position():

		if move_object == null or move_object.finished:
			stop_action()
			rat.action=follow_action
		else:
			if !fighting and !started_moving:
				started_moving = true
				move_object.add_mover()
				print("addddddddddddddd")
			set_target(move_object.global_position,o_rats)
		
	#rat.velocity = dir
	#rat.velocity.y -= 100*delta
	#rat.move_and_slide()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
