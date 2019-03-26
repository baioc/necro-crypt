extends Node


func _ready():
	$Camera.set_target($Player)


func _process(delta):
	if Input.is_action_pressed("ui_end"):
		get_tree().quit()
