extends RigidBody2D

export(float) var start_velocity = 100
export(float) var materialization_time = 0

func _ready():
	connect("body_enter", self, "_body_enter")
	set_linear_velocity(get_linear_velocity() + Vector2(0, start_velocity).rotated(get_rot()))
	set_rot(get_linear_velocity().angle())
	set_fixed_process(true)

func _fixed_process(delta):
	if materialization_time != false:
		materialization_time -= delta
		if materialization_time < 0:
			materialization_time = false
			set_layer_mask_bit(0, true)
	
	set_rot(get_linear_velocity().angle())

func _body_enter(body):
	queue_free()
