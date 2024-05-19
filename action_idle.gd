extends Node

func _ready():
	pass 
	
func act(rat: Node3D,delta):
	rat.look_at(rat.global_position+Vector3.LEFT,Vector3.UP)

func stop_action():
	pass

func _process(delta):
	pass
