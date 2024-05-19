extends Node3D

const SELECT_PLAYER = 0
const CHOOSE_ACTION = 1
const AIM_MOVABLE = 2
var state = 0
var selected_p_units = []
var drag_start:Vector2 = Vector2.ZERO
var drag_end: Vector2
@export var cam:Camera3D
@export var p_units: Node
@onready var mark = $mark_rect
var movable = null 
 
func _ready():
	mark.visible = false
	for c in p_units.get_children():
		c.family = 1
		c.family_changed = true

func _process(delta):
	if state == SELECT_PLAYER:
		if drag_start != Vector2.ZERO:
			drag_end = get_viewport().get_mouse_position()
			for c in p_units.get_children():
				var r = Rect2(Vector2(min(drag_start.x,drag_end.x),min(drag_start.y,drag_end.y)),(drag_end-drag_start).abs())
				if c.is_in_2d_selection(cam,r) and !c.death:
					c.marked = true
					selected_p_units.append(c)
				else:
					c.marked = false
			mark.visible = true
			mark.position = (drag_end+drag_start)/2
			mark.scale = (drag_end-drag_start).abs()
			
		if Input.is_action_just_pressed("mouse_left"):
			drag_start = get_viewport().get_mouse_position()
		if Input.is_action_just_released("mouse_left") and selected_p_units.size() != 0:
			drag_start = Vector2.ZERO
			mark.visible = false
			state = CHOOSE_ACTION
			
	elif state == CHOOSE_ACTION:
		if Input.is_action_just_pressed("mouse_left"):
			var m_pos = get_viewport().get_mouse_position()
			var query = PhysicsRayQueryParameters3D.create(cam.project_ray_origin(m_pos),cam.project_ray_normal(m_pos)*1000+ cam.project_ray_origin(m_pos))
			var d = get_world_3d().direct_space_state.intersect_ray(query)
			if d.has("collider"):
				if d["collider"].has_method("add_mover"):
					movable = d["collider"]
					state = AIM_MOVABLE
				else:
					for r in selected_p_units:
						if r != null and !r.death:
							r.walk.set_target(d["position"],p_units.get_children())
							r.action.stop_action()
							r.action = r.walk
							r.walk.follow_action = r.idle
					state = SELECT_PLAYER
					for p in selected_p_units:
						if p != null:
							p.marked = false
					selected_p_units=[]
					
	elif state == AIM_MOVABLE:
		if Input.is_action_just_pressed("mouse_left"):
			var m_pos = get_viewport().get_mouse_position()
			var query = PhysicsRayQueryParameters3D.create(cam.project_ray_origin(m_pos),cam.project_ray_normal(m_pos)*1000+ cam.project_ray_origin(m_pos))
			var d = get_world_3d().direct_space_state.intersect_ray(query)
			if d.has("collider"):
				movable.target = d["position"]
				movable.finished = false
				for r in selected_p_units:
					if r != null and !r.death:
						r.walk.set_target(movable.global_position,p_units.get_children())
						r.action.stop_action()
						r.action = r.walk
						r.walk.move_object = movable
						r.walk.follow_action = r.idle
				state = SELECT_PLAYER
				for p in selected_p_units:
					if p != null:
							p.marked = false
				selected_p_units=[]
		
