extends RigidBody2D

export(float) var start_velocity = 100
export(float) var additional_velocity = 0
export(float) var materialization_time = 0

onready var initial_velocity = get_linear_velocity() * 0

func _ready():
	connect("body_enter", self, "_body_enter")
	set_linear_velocity(get_linear_velocity() + Vector2(0, start_velocity).rotated(get_rot()))
	set_rot(get_linear_velocity().angle())

func _integrate_forces(state):
	if materialization_time < 0:
		materialization_time = 0
		set_layer_mask_bit(0, true)
	elif materialization_time > 0:
		materialization_time -= state.get_step()
	
	var velocity = state.get_linear_velocity()
	velocity += Vector2(0, additional_velocity).rotated(get_rot()) * state.get_step()
	
	set_rot((velocity - initial_velocity).angle())
	state.set_linear_velocity(velocity)

func _body_enter(body):
	queue_free()