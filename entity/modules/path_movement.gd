extends Node2D

export(float) var speed = 600
export(float) var max_velocity = 500
export(float) var bounce = 0.5
export(bool) var rotating = false

var entity = null
var path_follow = null
var reached_end = 0
var curve_length = 0

func set_entity(_entity):
	entity = _entity
	if path_follow:
		path_follow.queue_free()
		path_follow = null
	call_deferred("setup_path_follow")

func setup_path_follow():
	path_follow = PathFollow2D.new()
	
	var curve = entity.get_parent().get_curve()
	curve_length = curve.get_baked_length()
	if curve.get_point_pos(0).distance_to(curve.get_point_pos(curve.get_point_count() - 1)) < 1:
		path_follow.set_loop(true)
	else:
		path_follow.set_loop(false)
	
	entity.get_parent().add_child(path_follow)
	entity.set_pos(path_follow.get_pos())

func set_default_inputs(inputs):
	inputs.right = 0
	inputs.left = 0

func integrate_forces(state, inputs):
	if !path_follow: return
	
	var delta = state.get_step()
	var velocity = state.get_linear_velocity()
	
	var path_normal = Vector2(0,-1).rotated(path_follow.get_rot())
	var path_tangent = Vector2(-1,0).rotated(path_follow.get_rot())
	
	var path_velocity = velocity.dot(path_tangent) + abs(velocity.dot(path_normal)) * bounce
	path_velocity = clamp(path_velocity, -max_velocity, max_velocity)
	
	var old_path_follow_offset = path_follow.get_offset()
	path_follow.set_offset(path_follow.get_offset() - path_velocity * delta)
	
	if path_follow.get_offset() >= curve_length:
		reached_end = 1
		path_velocity = 0
	elif path_follow.get_offset() <= 0:
		reached_end = -1
		path_velocity = 0
	else:
		reached_end = 0
	
	var new_transform = Matrix32(0, path_follow.get_global_pos())
	if rotating:
		new_transform = new_transform.rotated(path_follow.get_global_rot())
	
	state.set_transform(new_transform)
	
	var path_move = 0 + inputs.right - inputs.left
	if path_move != 0 and path_move * reached_end >= 0:
		path_velocity += path_move * speed * delta
		path_velocity = clamp(path_velocity, -max_velocity, max_velocity)
	
	velocity = path_velocity * path_tangent
	state.set_linear_velocity(velocity)
	for i in range(state.get_contact_count()):
		var other = state.get_contact_collider_object(i)
		if other extends RigidBody2D:
			var other_velocity = other.get_linear_velocity()
			var velocity_normal = velocity.normalized()
			var dot = velocity_normal.dot(other_velocity)
			other.apply_impulse(other.get_global_pos(), (velocity - velocity_normal * dot) * delta)
	state.set_angular_velocity(0)

func get_reached_end():
	return reached_end
