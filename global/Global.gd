extends Node2D


onready var box = $Interface_control/Box
var initial_pos
var current_pos
var selection_rect

func _process(delta):
	_input(true)
	_create_box()


func _input(event):
	if Input.is_action_just_pressed("ui_end"):
		get_tree().quit()
	elif Input.is_action_just_pressed("ui_accept"):
		for unit in $Monsters.get_children():
			if unit.selection:
				unit.goto(get_global_mouse_position())


func _create_box():
	if Input.is_action_just_pressed("ui_select"):
		initial_pos = get_global_mouse_position()
		box.set_begin(get_global_mouse_position())
	elif Input.is_action_pressed("ui_select"):
		current_pos = get_global_mouse_position()
		box.set_begin(Vector2(min(initial_pos.x, current_pos.x), min(initial_pos.y, current_pos.y)))
		box.set_end(Vector2(max(initial_pos.x,current_pos.x), max(initial_pos.y, current_pos.y)))
	elif Input.is_action_just_released("ui_select"):
		_select_allies()
		box.set_begin(Vector2(0,0))
		box.set_end(Vector2(0,0))

# TODO selecionar as tropas com apena um click
func _select_allies():
	selection_rect = box.get_rect()
	for unit in $Monsters.get_children():
		unit.select(selection_rect.has_point(unit.get_position()))