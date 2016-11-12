extends Node2D

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

var jump_continuation_left = 0
var jump_debounce_left = 0
var entity = null

func _ready():
	pass

func set_entity(_entity):
	entity = _entity

func set_default_inputs(inputs):
	inputs.right = 0
	inputs.left = 0
	inputs.up = false

func integrate_forces(state, inputs):
	var delta = state.get_step()
	var velocity = state.get_linear_velocity()
	var friction = standing_friction
	
	if !inputs.is_grounded:
		friction = moving_friction # Allows for better sliding on walls after jumping
	
	var horizontal_move = 0 + inputs.right - inputs.left
	
	if horizontal_move != 0:
		
		if velocity.normalized().x * horizontal_move > -0.1:
			friction = moving_friction
		
		if velocity.x * horizontal_move < max_velocity: # If it is larger, don't clamp it, but don't move either
			velocity.x += horizontal_move * speed * delta
			velocity.x = clamp(velocity.x, -max_velocity, max_velocity)
	
	
	jump_debounce_left -= delta
	var last_jump_power = ease(1 - jump_continuation_left, jump_continuation_curve)
	jump_continuation_left -= delta / jump_continuation
	var jump_power = ease(1 - jump_continuation_left, jump_continuation_curve)
	if inputs.up:
		if inputs.is_grounded and jump_debounce_left <= 0:
			velocity.y = -jump - abs(velocity.x) * velocity_to_jump
			jump_continuation_left = 1
			jump_debounce_left = jump_debounce
			last_jump_power = 0
		elif jump_continuation_left > 0 and velocity.y < 0:
			velocity.y += -jump_continuation_velocity * (jump_power - last_jump_power)
	
	entity.set_friction(friction)
	state.set_linear_velocity(velocity)

