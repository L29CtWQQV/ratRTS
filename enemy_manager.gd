extends Node3D
@export var e_units : Node3D
@onready var points = $"points"
var time = 2
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time -= delta
	if time < 0:
		var p = points.get_child(randi_range(0,points.get_child_count()-1))
		var g = e_units.get_child(randi_range(0,e_units.get_child_count()-1))
		for e in g.get_children():
			if !e.death:
				e.walk.set_target(p.global_position,g.get_children())
				e.action.stop_action()
				e.action = e.walk
				e.walk.follow_action = e.idle
		time = randf_range(0,4)
