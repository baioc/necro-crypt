extends Control


var selected := []

var initial_pos : Vector2


func selection_begin(initial_pos : Vector2):
	self.initial_pos = initial_pos
	selection_update(initial_pos)

	$Selection.set_visible(true)


func selection_update(current_pos : Vector2):
	# allows selecting over multiple directions
	$Selection.set_begin(Vector2(
			min(initial_pos.x, current_pos.x),
			min(initial_pos.y, current_pos.y)))
	$Selection.set_end(Vector2(
			max(initial_pos.x,current_pos.x),
			max(initial_pos.y, current_pos.y)))

	# center area rectangle shape in selection box
	var half_size : Vector2 = $Selection.get_size() / 2
	$Selection/Area/Collider.shape.set_extents(half_size)
	$Selection/Area.set_global_position($Selection.get_begin() + half_size)


func selection_apply():
	for unit in selected:
		unit.select(false)

	selected.clear()

	for unit in $Selection/Area.get_overlapping_bodies():
		unit.select(true)
		selected.append(unit)

	$Selection.set_visible(false)


func _process(delta):
	if Input.is_action_just_pressed("ui_select"):
		selection_begin(get_global_mouse_position())
	elif Input.is_action_pressed("ui_select"):
		selection_update(get_global_mouse_position())
	elif Input.is_action_just_released("ui_select"):
		selection_apply()

	elif Input.is_action_just_pressed("ui_accept"):
		for unit in selected:
			if unit.is_controllable():
				unit.goto(get_global_mouse_position())
		# @TODO: other commands
