extends Control


var troops := []

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
	selection_clear()

	for unit in $Selection/Area.get_overlapping_bodies():
		if unit.is_controllable():
			selection_add(unit)

	$Selection.set_visible(false)


func selection_clear():
	for unit in troops:
		unit.select(false)

	troops.clear()


func selection_add(unit):
	unit.select(true)
	troops.append(unit)


func _physics_process(delta): # using _physics for world space state
	if Input.is_action_just_pressed("ui_select"):
		selection_begin(get_global_mouse_position())
	elif Input.is_action_pressed("ui_select"):
		selection_update(get_global_mouse_position())
	elif Input.is_action_just_released("ui_select"):
		selection_apply()

	if Input.is_action_just_pressed("ui_accept"):
		# find at most 1 unit under mouse
		var mouse := get_global_mouse_position()
		var space := get_world_2d().get_direct_space_state()
		var clicked := space.intersect_point(mouse, 1, [self], $Selection/Area.get_collision_mask())
		var found = clicked.pop_front()

		if found == null or found["collider"].is_controllable():
			for unit in troops:
				unit.goto(mouse)
		elif found["collider"].is_dead():
			found["collider"].reanimate()
			selection_clear()
			selection_add(found["collider"])
		else:
			for unit in troops:
				unit.attack(found["collider"])

	if Input.is_action_just_pressed("ui_cancel"):
		for unit in troops:
			unit.idle()
