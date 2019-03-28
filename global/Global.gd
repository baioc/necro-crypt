extends Node


func _ready():
	$Camera.set_target($Player)

	# @NOTE: testing undeath
	$Monsters/Monster_2.update_health(-$Monsters/Monster_2.health)


func _process(delta):
	if Input.is_action_pressed("ui_end"):
		get_tree().quit()
