extends Node2D

var active = false
var entity

func _ready():
	InputSwitcher.register_input(self)

func _exit_tree():
	InputSwitcher.unregister_input(self)

func activate():
	active = true
	var camera = entity.get_node("camera")
	camera.make_current()
	camera.reset_smoothing()

func deactivate():
	active = false

func is_active():
	return active

func force_switch():
	InputSwitcher.switch_to(self)

func set_entity(_entity):
	entity = _entity

func set_inputs(inputs):
	if active:
		inputs.up = float(Input.is_action_pressed("jump"))
		inputs.down = float(Input.is_action_pressed("land"))
		inputs.left = float(Input.is_action_pressed("left"))
		inputs.right = float(Input.is_action_pressed("right"))
		inputs.shoot = Input.is_action_pressed("shoot")
		inputs.shoot_at = get_global_mouse_pos()
		inputs.detach = Input.is_action_pressed("detach")
	else:
		inputs.up = false
		inputs.left = 0
		inputs.right = 0
		inputs.shoot = false
		inputs.detach = false
