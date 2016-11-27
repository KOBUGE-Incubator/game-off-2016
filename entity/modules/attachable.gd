extends Node2D

export(float) var detach_debounce = 0.6
export(Vector2) var detach_velocity = Vector2(0, -100)

var detach_debounce_left = 0
var applied_velocity = false
var entity = null
var main_body = null
var main_module = null

func _ready():
	pass

func set_entity(_entity):
	entity = _entity

func set_main_body(body):
	main_body = body
	detach_debounce_left = detach_debounce
	applied_velocity = false

func set_main_module(body):
	main_module = body

func integrate_forces(state, inputs):
	var delta = state.get_step()

	detach_debounce_left -= delta
	if detach_debounce_left < 0 and inputs.is_grounded and inputs.ground == main_body:
		print("ATTACH")
		detach_debounce_left = detach_debounce
		main_module.call_deferred("reattach")
	if !applied_velocity:
		state.set_linear_velocity(state.get_linear_velocity() + detach_velocity)
		applied_velocity = true
		
