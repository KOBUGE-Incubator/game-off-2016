extends RigidBody2D

export(float) var slope_treshold = 0.4

onready var feet = [
	get_node("jump_ray_left"),
	get_node("jump_ray_right")
]

var modules = []
var is_grounded = false
var inputs = {}

func _enter_tree():
	add_to_group("entity")
	update_modules()

func update_modules():
	var to_check = get_node("modules").get_children()
	modules = []
	while to_check.size():
		var module = to_check[to_check.size()-1]
		to_check.pop_back()
		
		if module.get_script():
			modules.push_back(module)
		
		to_check += module.get_children()
	
	inputs = {} # Reset only here, assume nobody does something evil
	for module in modules:
		if module.has_method("set_default_inputs"):
			module.set_default_inputs(inputs)
		if module.has_method("set_entity"):
			module.set_entity(self)

func _integrate_forces(state):
	inputs.is_grounded = false
	for foot in feet:
		if foot.is_colliding() and foot.get_collision_normal().dot(Vector2(0, -1)) > slope_treshold:
			inputs.is_grounded = true
			break
	
	for module in modules:
		if module.has_method("set_inputs"):
			module.set_inputs(inputs)
	
	for module in modules:
		if module.has_method("integrate_forces"):
			module.integrate_forces(state, inputs)
	
