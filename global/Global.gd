extends Node


func _ready():
	$Camera.set_target($Player/Character)


func _process(delta):
	if Input.is_action_pressed("ui_end"):
		get_tree().quit()

	# target player when out of immediate combat
	for monster in $Monsters.get_children():
		if monster.is_in_group("enemies") and monster.is_idle():
			monster.attack($Player/Character)
