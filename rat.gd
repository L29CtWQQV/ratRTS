extends Node3D

@onready var idle = $action_idle;
@onready var walk = $action_walking_to;
@onready var target = $"./gl/target"
var speed = 9
var marked = false
var t = 0
var action = idle
var death = false
var allow_movement = true
var family = 0
func _ready():
	action = idle

func is_in_2d_selection(cam: Camera3D,r:Rect2):
	var p = cam.unproject_position(position)
	return r.has_point(p)

func kill():
	print("killledd")
	if !death:
		death
		action.stop_action()
		queue_free()

func _process(delta):
	t += delta
	action.act(self,delta)
	
	if marked:
		var a = 1+sin(t *4)/6
		scale = Vector3(a,a,a)
	else:
		scale = Vector3(1,1,1)

