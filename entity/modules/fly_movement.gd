extends Node2D

export(Vector2) var speed = Vector2(600, 300)
export(float) var max_velocity = 500
export(float) var moving_friction = 0.1
export(float) var standing_friction = 0.7

var entity = null

func _ready():
	pass

func set_entity(_entity):
	entity = _entity

func set_default_inputs(inputs):
	inputs.right = 0
	inputs.left = 0
	inputs.up = 0
	inputs.down = 0

func integrate_forces(state, inputs):
	var delta = state.get_step()
	var velocity = state.get_linear_velocity()
	var friction = standing_friction

	if !inputs.is_grounded:
		friction = moving_friction # Allows for better sliding on walls after jumping

	var move = Vector2(0 + inputs.right - inputs.left, 0 - inputs.up + inputs.down)

	if move.length_squared() > 0.01:
		if velocity.normalized().dot(move) > -0.1:
			friction = moving_friction

		velocity += move * speed * delta
		velocity = velocity.clamped(max_velocity)

	entity.set_friction(friction)
	state.set_linear_velocity(velocity)

