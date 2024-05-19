extends CharacterBody3D
var dangerous = false
var finished = true
var target = Vector3.ZERO
var movers = 0
@onready var ray = $"RayCast3D"
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
		if d.length() <2:
			finished = true
		d.y = 0
		d *= min(1/d.length()*movers/10,1.0)
	

		
	if is_on_floor():
		#if is_on_floor():
		velocity = d
		velocity.y = 0
		dangerous = false

		move_and_slide()
	else:
		if abs(velocity.y) >5:
			dangerous = true
			finished = true

		velocity.x = d.x
		velocity.z = d.z
		velocity.y -= 50*delta
		move_and_slide()
		if dangerous:
			for i in range(get_slide_collision_count()):
				if get_slide_collision(i).get_collider().has_method("kill"):
					get_slide_collision(i).get_collider().kill()
