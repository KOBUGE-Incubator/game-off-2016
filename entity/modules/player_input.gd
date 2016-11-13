extends Node2D

var active = false
var entity

func _ready():
	InputSwitcher.register_input(self)

func _exit_tree():
	entity.remove_from_group("player")
	InputSwitcher.unregister_input(self)

func activate():
	active = true
	entity.get_node("camera").make_current()

func deactivate():
	active = false

func set_entity(_entity):
	if entity != null:
		entity.remove_from_group("player")
	entity = _entity
	entity.add_to_group("player")

func set_inputs(inputs):
	if active:
		inputs.up = Input.is_action_pressed("jump")
		inputs.left = float(Input.is_action_pressed("left"))
		inputs.right = float(Input.is_action_pressed("right"))
		inputs.shoot = Input.is_action_pressed("shoot")
		inputs.shoot_at = get_global_mouse_pos()
	else:
		inputs.up = false
		inputs.left = 0
		inputs.right = 0
		inputs.shoot = false
