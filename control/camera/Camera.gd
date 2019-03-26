extends Node2D


enum STATE { FREE, LOCKED, MOVING }
var state = STATE.LOCKED

var focus : Node2D = self


func goto(target : Vector2):
	set_global_position(target)
	$Camera.align()


func set_target(target : Node2D):
	focus = target


func _process(delta):
	_check_input()
	_control()


func _check_input():
	if Input.is_action_just_pressed("ui_camera_lock"):
		if STATE.FREE == state:
			state = STATE.LOCKED
		else:
			state = STATE.FREE

	elif Input.is_action_pressed("ui_camera_center"):
		state = STATE.MOVING
		# blocks input checking until timeout
		$MoveTimer.start()
		yield($MoveTimer, "timeout")


func _control():
	match state:
		STATE.FREE:
			set_position(get_global_mouse_position())
		STATE.LOCKED:
			goto(focus.get_global_position())
		STATE.MOVING:
			goto(focus.get_global_position())
			if $MoveTimer.is_stopped():
				state = STATE.FREE
