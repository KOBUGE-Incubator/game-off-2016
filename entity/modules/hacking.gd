extends Node2D

export(float) var efficiency = 1

var entity = null
var time_left = 0
var target = null

func _ready():
	pass

func set_entity(_entity):
	entity = _entity

func set_default_inputs(inputs): # TODO: use some simpler selection method
	inputs.shoot = false
	inputs.shoot_at = Vector2()

func integrate_forces(state, inputs):
	var direct_space_state = get_world_2d().get_direct_space_state()
	var delta = state.get_step()
	time_left -= delta
	
	if target != null and !target.has_module("player_input"):
		if time_left < 0:
			target.add_module(preload("res://entity/modules/player_input.gd").new())
			target = null
	else:
		target = null
		if inputs.shoot:
			var results = direct_space_state.intersect_point(inputs.shoot_at)
			for result in results:
				var possible_target = result.collider
				if possible_target extends preload("res://entity/entity.gd"):
					if !possible_target.has_module("player_input") and possible_target.get_hackpoints() > 0: # < 0 -> unhackable
						target = possible_target
						time_left = possible_target.get_hackpoints() / efficiency

