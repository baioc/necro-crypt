extends Node2D


enum STATE { FREE, LOCKED, MOVING }
var state = STATE.FREE
var focus : Node2D = self


func goto(target : Vector2):
	set_global_position(target)
	$Camera.align()


func set_target(focus : Node2D):
	if focus:
		self.focus = focus


func get_target() -> Node2D:
	return focus


func _ready():
	set_target(get_tree().get_root().get_node("World/Player"))


func _process(delta):
	_check_input()
	_control(delta)


func _check_input():
	if Input.is_action_just_pressed("ui_camera_center"):
		state = STATE.MOVING
		# Blocks input checking until timeout
		$MoveTimer.start()
		yield($MoveTimer, "timeout")

	if Input.is_action_just_pressed("ui_camera_lock"):
		if STATE.FREE == state:
			state = STATE.LOCKED
		else:
			state = STATE.FREE


func _control(delta):
	match state:
		STATE.FREE:
			set_position(get_global_mouse_position())
		STATE.LOCKED:
			goto(focus.get_global_position())
		STATE.MOVING:
			goto(focus.get_global_position())
			if $MoveTimer.is_stopped():
				state = STATE.FREE
