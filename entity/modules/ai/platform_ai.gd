extends Node2D

export(float) var stay_time = 0.6

var path_movement = null
var entity = null
var stay_time_left = 0
var direction = 1

func _ready():
	pass

func set_entity(_entity):
	entity = _entity

func set_inputs(inputs):
	if stay_time_left > 0:
		inputs.left = 0
		inputs.right = 0
	elif direction > 0:
		inputs.left = direction
		inputs.right = 0
	else:
		inputs.left = 0
		inputs.right = -direction

func integrate_forces(state, inputs):
	stay_time_left -= state.get_step()
	
	if !path_movement:
		if entity.has_module("path_movement"):
			path_movement = entity.get_module("path_movement")
		else:
			return
	
	if stay_time_left < 0:
		if path_movement.get_reached_end() == direction:
			direction = -direction
			stay_time_left = stay_time
