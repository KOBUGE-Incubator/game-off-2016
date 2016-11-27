extends Node2D

export(PackedScene) var detach_part
export(bool) var auto_switch_input = true
export(Vector2) var offset = Vector2()

var entity = null
var detached_body = null
var detached = false

func _ready():
	detached_body = detach_part.instance()

func set_entity(_entity):
	entity = _entity

func set_default_inputs(inputs):
	inputs.detach = false

func integrate_forces(state, inputs):
	var delta = state.get_step()
	if !detached and inputs.detach:
		print("DETACH")
		detached = true
		switch_body_parts()
		entity.get_parent().add_child(detached_body)
		detached_body.set_global_pos(entity.get_global_pos() + offset)
		detached_body.set_linear_velocity(entity.get_linear_velocity())
		if detached_body.has_module("attachable"):
			var attachable = detached_body.get_module("attachable")
			attachable.set_main_body(entity)
			attachable.set_main_module(self)
		if auto_switch_input and detached_body.has_module("player_input"):
			detached_body.get_module("player_input").force_switch()

func reattach():
	if detached:
		if auto_switch_input and entity.has_module("player_input"):
			entity.get_module("player_input").force_switch()
		detached_body.get_parent().remove_child(detached_body)
		detached = false
		switch_body_parts()

func switch_body_parts():
	if detached:
		entity.set_mass(entity.get_mass() - detached_body.get_mass())
	else:
		entity.set_mass(entity.get_mass() + detached_body.get_mass())
	
	for child in entity.get_children():
		if child.get_name().ends_with("detach"):
			if child extends CanvasItem:
				child.set_hidden(detached)
			if child extends CollisionShape2D:
				if detached:
					for i in range(entity.get_shape_count()-1, -1, -1):
						if entity.get_shape(i) == child.get_shape():
							entity.remove_shape(i)
							break
				else:
					entity.add_shape(child.get_shape(), child.get_transform())
				#child.set_trigger(detached)

