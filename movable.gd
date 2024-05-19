extends CharacterBody3D
var dangerous = false
var finished = true
var target = Vector3.ZERO
var movers = 0

func add_mover():
	movers += 1
func remove_mover():
	movers -= 1
	
func activate(target):
	finished = false
	
func _ready():
	pass
	
func _process(delta):
	var d = Vector3.ZERO
	if !finished:
		d = (target-global_position)
		if d.length() <1:
			finished = true
		d.y = 0
		d *= min(1/d.length()*movers*delta/10,1.0)
	
	#if is_on_floor():
	velocity.y = 0
	dangerous = false
	global_position += d
	
		
	if !is_on_floor():
		velocity.y -= 5*delta
		#dangerous = true
		#finished = true
		d.y = velocity.y
		velocity = d

		if dangerous:
			for i in range(get_slide_collision_count()):
				if get_slide_collision(i).get_collider().has_method("kill"):
					get_slide_collision(i).get_collider().kill()
