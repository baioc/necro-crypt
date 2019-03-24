extends Node2D

func _process(delta):
	if Input.is_action_just_pressed("ui_end"):
		get_tree().quit()

	elif Input.is_action_just_pressed("ui_accept"):
		for unit in $Monsters.get_children():
			unit.goto(get_global_mouse_position())
