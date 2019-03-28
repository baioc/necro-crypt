extends "res://entities/Entity.gd"


export var friend : bool = false
var selected : bool = false

enum STATE { IDLE, MOVE, FIGHT }
var state = STATE.IDLE
var target : Node2D = null


func goto(location : Vector2):
	print("march!")
	target = Node2D.new()
	get_parent().add_child(target)
	target.set_global_position(location)
	state = STATE.MOVE


func attack(entity : Node2D):
	print("attack!")
	target = entity
	state = STATE.FIGHT


func idle():
	print("halt!")
	target = null
	state = STATE.IDLE


func select(flag : bool):
	selected = flag
	if selected:
		_on_mouse_entered()
	else:
		_on_mouse_exited()


func is_controllable() -> bool:
	return friend


func control(flag : bool):
	friend = flag
	if not friend:
		$Selection.set_modulate(Color.red)
	else:
		$Selection.set_modulate(Color.green)


func die():
	print("died.")
	if not is_controllable():
		idle()
		select(false)
		set_modulate(Color.blue)
	else:
		.die() # you only undie once


func reanimate():
	print("reanimate!")
	update_health(health_max)
	set_modulate(Color.white)
	control(true)


func _ready():
	control(self.friend)


func _control(delta):
	match state:
		STATE.MOVE:
			_move()
		STATE.FIGHT:
			_fight()
		STATE.IDLE:
			_idle()


func _move():
	var dir := target.get_global_position() - self.get_global_position()
	# @TODO: better unit formation when reaching target location
	if dir.length() > attack_range:
		# @TODO: pathfind towards target
		velocity = dir.normalized() * speed
	else:
		idle()


func _fight():
	if target == null:
		idle()
		return

	var dir := target.get_global_position() - self.get_global_position()
	if dir.length() <= attack_range:
		_hit(dir)
	else:
		_move()


func _idle():
	velocity = ZERO


func _on_mouse_entered():
	$Selection.set_visible(true)


func _on_mouse_exited():
	if not selected:
		$Selection.set_visible(false)
