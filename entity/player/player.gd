extends RigidBody2D

export(float) var speed = 600
export(float) var max_velocity = 500
export(float) var jump = 300
export(float) var velocity_to_jump = 0.2
export(float) var jump_continuation = 1
export(float) var jump_debounce = 0.3
export(float, EASE) var jump_continuation_curve = 1
export(float) var jump_continuation_velocity = 100
export(float) var moving_friction = 0.1
export(float) var standing_friction = 0.7
export(float) var slope_treshold = 0.4

var jump_continuation_left = 0
var jump_debounce_left = 0

onready var feet = [
	get_node("jump_ray_left"),
	get_node("jump_ray_right")
]

func _ready():
	print(get('jump'))
	pass

func _integrate_forces(state):
	var delta = state.get_step()
	
	var is_grounded = false
	
	for foot in feet:
		if foot.is_colliding() and foot.get_collision_normal().dot(Vector2(0, -1)) > slope_treshold:
			is_grounded = true
			break
	
	var move = 0
	if Input.is_action_pressed("ui_right"):
		move += 1
	if Input.is_action_pressed("ui_left"):
		move -= 1
	
	var friction = standing_friction
	if !is_grounded:
		friction = moving_friction # Better wall-sliding
	if move != 0:
		var velocity = state.get_linear_velocity()
		if velocity.normalized().dot(Vector2(move, 0)) > -0.1:
			friction = moving_friction
		if velocity.x * move < max_velocity:
			velocity.x = clamp(velocity.x + move * speed * delta, -max_velocity, max_velocity)
			state.set_linear_velocity(velocity)
	
	set_friction(friction)
	
	
	var last_jump_power = ease(1 - jump_continuation_left, jump_continuation_curve)
	jump_continuation_left -= delta / jump_continuation
	jump_debounce_left -= delta
	var jump_power = ease(1 - jump_continuation_left, jump_continuation_curve)
	if Input.is_action_pressed("ui_up"):
		var velocity = state.get_linear_velocity()
		if is_grounded and jump_debounce_left <= 0:
			velocity.y = -jump - abs(velocity.x) * velocity_to_jump
			state.set_linear_velocity(velocity)
			jump_continuation_left = 1
			jump_debounce_left = jump_debounce
			last_jump_power = 0
		elif jump_continuation_left > 0 and velocity.y < 0:
			velocity.y += -jump_continuation_velocity * (jump_power - last_jump_power)
			state.set_linear_velocity(velocity)
	
