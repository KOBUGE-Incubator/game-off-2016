extends Control

func _ready():
	pass#play()

func play():
	get_tree().change_scene("res://main/main.tscn")

func quit():
	get_tree().quit()
