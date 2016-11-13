extends Node2D

export(Vector2) var aim_offset = Vector2(0,0)
export(Vector2) var aim_velocity_bias = Vector2(0,0)
export(float) var aim_velocity_bias_distance_scale = 1
export(float) var velocity_to_shot_speed = 0.6

var entity = null
var target = null

func _ready():
	pass

func set_entity(_entity):
	entity = _entity

func set_inputs(inputs):
	var my_pos = entity.get_global_pos()
	var direct_space_state = get_world_2d().get_direct_space_state()
	if target == null:
		var min_squared_distance = -1
		for player in get_targets():
			var result = direct_space_state.intersect_ray(my_pos, calculate_aim_pos(player), [entity, player], 1)
			if result.empty():
				var distance_squared = my_pos.distance_squared_to(player.get_global_pos())
				if min_squared_distance < 0 or min_squared_distance > distance_squared:
					target = player
					min_squared_distance = distance_squared
	else:
		var result = direct_space_state.intersect_ray(my_pos, calculate_aim_pos(target), [entity, target], 1)
		if !result.empty():
			target = null
	
	if target != null:
		inputs.shoot = true
		inputs.shoot_at = calculate_aim_pos(target) - entity.get_linear_velocity() * velocity_to_shot_speed # TODO: incorrect
	else:
		inputs.shoot = false

func calculate_aim_pos(to):
	var target_pos = to.get_global_pos()
	var delta_pos = entity.get_global_pos() - target_pos
	var distance = delta_pos.length()
	var aim_pos = target_pos + aim_offset + aim_velocity_bias * to.get_linear_velocity() * (distance / aim_velocity_bias_distance_scale)
	return aim_pos

func get_targets():
	var possible_targets = get_tree().get_nodes_in_group("entity")
	var invert = entity.is_in_group("player")
	var targets = []
	for target in possible_targets:
		if (target.is_in_group("player") and !invert) or (!target.is_in_group("player") and invert):
			targets.push_back(target)
	return targets
