extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func act(rat: CharacterBody3D,delta):

	rat.velocity = Vector3.ZERO
	#rat.velocity.y -= 100*delta
	rat.move_and_slide()

func stop_action():
	pass

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
