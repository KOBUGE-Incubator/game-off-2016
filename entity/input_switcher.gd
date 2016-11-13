extends Node

var active_input = -1
var inputs = []

func _ready():
	set_process_input(true)

func _input(event):
	if event.is_action_pressed("switch"):
		next_input()

func register_input(input):
	inputs.push_back(input)
	if active_input == -1:
		input.activate()
		active_input = 0

func unregister_input(input):
	var index = inputs.find(input)
	if active_input == index:
		next_input()
		if active_input > index:
			active_input -= 1
	inputs.remove(index)

func next_input():
	inputs[active_input].deactivate()
	active_input += 1
	if active_input >= inputs.size():
		active_input -= inputs.size()
	inputs[active_input].activate()