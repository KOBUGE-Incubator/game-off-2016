extends Node2D

func _ready():
	pass

func set_inputs(inputs):
	inputs.up = Input.is_action_pressed("jump")
	inputs.left = float(Input.is_action_pressed("left"))
	inputs.right = float(Input.is_action_pressed("right"))
	inputs.shoot = Input.is_action_pressed("shoot")
	inputs.shoot_at = get_global_mouse_pos()