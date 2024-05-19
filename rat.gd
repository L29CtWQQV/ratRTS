extends Node3D

@onready var idle = $action_idle
@onready var walk = $action_walking_to
@onready var target = $"./gl/target"
@onready var sp1 = $"sp1" 
@onready var sp2 = $"sp2"
@onready var part = $"GPUParticles3D"
var speed = 9
var marked = false
var t = 0
var action = idle
var death = false
var allow_movement = true
var family = 0
var family_changed = true
func _ready():
	action = idle
var close_enemys = []
	
func set_family():
	if family ==1:
		sp2.visible = true
		sp1.visible = false
		sp2.play("default")
		sp1.stop()
	else:
		sp2.visible = false
		sp1.visible = true
		sp1.play("default")
		sp2.stop()
		

func is_in_2d_selection(cam: Camera3D,r:Rect2):
	var p = cam.unproject_position(position)
	return r.has_point(p)

func kill():
	print("killledd")
	if !death:
		death = true
		action.stop_action()
		#queue_free()
	action = idle
	sp1.play("die")
	sp2.play("die")
	part.emitting = true
	

func _process(delta):
	if family_changed:
		set_family()
		family_changed = false
	t += delta
	
	if !death and close_enemys.size() != 0 and (action != walk or !walk.fighting):
		if close_enemys[0].death:
			close_enemys.remove_at(0)
		else:
			action.stop_action()
			action = walk
			walk.fighting = true
			walk.set_target(close_enemys[0].global_position,walk.o_rats)
			walk.follow_action = idle
			walk.move_object = close_enemys[0]
		
		
	action.act(self,delta)
	
	if marked:
		var a = 1+sin(t *4)/6
		scale = Vector3(a,a,a)
	else:
		scale = Vector3(1,1,1)



func _on_search_area_entered(area):
	var r =  area.get_parent()
	if r.has_method("kill") and r.family != family:
		close_enemys.append(r)


func _on_search_area_exited(area):
	var r =  area.get_parent()
	close_enemys.erase(r)
