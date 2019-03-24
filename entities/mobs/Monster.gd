extends "res://entities/Entity.gd"


enum STATE { IDLE, MOVE, FIGHT }
var state = STATE.IDLE
var target : Node2D = null


func goto(location : Vector2):
	target = Node2D.new()
	target.set_global_position(location)
	state = STATE.MOVE


func attack(entity : Node2D):
	target = entity
	state = STATE.FIGHT


func idle():
	target = null
	state = STATE.IDLE


func _move():
	var dir := target.get_global_position() - self.get_global_position()
	# @TODO: better unit formation when reaching target location
	if dir.length() > attack_range:
		# @TODO: pathfind towards target
		velocity = dir.normalized() * speed
	else:
		idle()


func _fight():
	if not target:
		idle()
		return

	var dir := target.get_global_position() - self.get_global_position()
	if dir.length() <= attack_range:
		_hit(dir)
	else:
		_move()


func _idle():
	# @TODO: Roam around when enemy, stand still when friend
	velocity = ZERO


func _control(delta):
	match state:
		STATE.MOVE:
			_move()
		STATE.FIGHT:
			_fight()
		STATE.IDLE:
			_idle()