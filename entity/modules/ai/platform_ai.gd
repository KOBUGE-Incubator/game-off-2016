extends Node2D

export(float) var power = 0.6
export(float) var deactivate_stay_time = 1
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
	if entity.has_module("player_input") and entity.get_module("player_input").is_active():
		stay_time_left = deactivate_stay_time
		return
	if stay_time_left > 0:
		inputs.left = 0
		inputs.right = 0
	elif direction > 0:
		inputs.left = direction * power
		inputs.right = 0
	else:
		inputs.left = 0
		inputs.right = -direction * power

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
