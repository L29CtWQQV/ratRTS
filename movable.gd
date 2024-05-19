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
		if d.length() <1.3:
			finished = true
		d.y = 0
		d *= min(1/d.length()*movers*3,1.0)
	

		
	if is_on_floor():
		#if is_on_floor():
		velocity = d
		velocity.y = 0
		dangerous = false

		move_and_slide()
	else:
		if abs(velocity.y) >5:
			dangerous = true
			#finished = true

		velocity.x = d.x
		velocity.z = d.z
		velocity.y -= 50*delta
		move_and_slide()
		#if dangerous:
		#	for i in range(get_slide_collision_count()):
		#		if get_slide_collision(i).get_collider().has_method("kill"):
		#			get_slide_collision(i).get_collider().kill()


func _on_area_3d_area_entered(area):
	var r = area.get_parent()

	if r.has_method("kill"):
		var d = area.global_position - global_position
		global_position -= d /100
		if dangerous:
			r.kill()
		else:
			r.allow_movement = false
			
		


func _on_area_3d_area_exited(area):
	var r = area.get_parent()

	if r.has_method("kill"):
		r.allow_movement = true
			
		
	
