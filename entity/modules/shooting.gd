extends Node2D

export(PackedScene) var shot_scene = preload("res://entity/shots/shot.tscn")
export(float) var cooldown = 0.3
export(float) var offset = 20
export(float) var velocity_to_speed = 0.6

var cooldown_left = 0
var entity = null

func _ready():
	pass

func set_entity(_entity):
	entity = _entity

func set_default_inputs(inputs):
	inputs.shoot = false
	inputs.shoot_at = Vector2()

func integrate_forces(state, inputs):
	var delta = state.get_step()
	cooldown_left -= delta
	
	if inputs.shoot and cooldown_left < 0:
		var direction = -(get_global_pos() - inputs.shoot_at).normalized()
		var shot = shot_scene.instance()
		
		shot.set_pos(entity.get_pos() + direction * offset)
		shot.set_rot(direction.angle()) # Might go wild
		shot.set_linear_velocity(entity.get_linear_velocity() * velocity_to_speed)
		
		entity.get_parent().add_child(shot)
		
		cooldown_left = cooldown

