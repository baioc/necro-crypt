extends Node2D


enum STATE { free, locked, moving }
var state = STATE.locked

var focus : WeakRef


func goto(target : Vector2):
	set_global_position(target)
	$Camera.align()


func set_target(target : Node2D):
	focus = weakref(target)


func _process(delta):
	_check_input()
	_control()


func _check_input():
	if Input.is_action_just_pressed("ui_camera_lock"):
		if STATE.free == state:
			state = STATE.locked
		else:
			state = STATE.free

	elif Input.is_action_pressed("ui_camera_center"):
		state = STATE.moving
		# blocks input checking until timeout
		$MoveTimer.start()
		yield($MoveTimer, "timeout")


func _control():
	# check if target was destroyed
	if !focus.get_ref():
		state = STATE.free
		set_target(self)

	match state:
		STATE.free:
			set_position(get_global_mouse_position())
		STATE.locked:
			goto(focus.get_ref().get_global_position())
		STATE.moving:
			goto(focus.get_ref().get_global_position())
			if $MoveTimer.is_stopped():
				state = STATE.free
