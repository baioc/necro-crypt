extends "res://entities/Entity.gd"


export var friend : bool = false
export var friendly_texture : Texture
export var enemy_texture : Texture
var selected : bool = false

enum STATE { idle, move, fight }
var state = STATE.idle
var target : Node2D = null


func goto(location : Vector2):
	target = Node2D.new()
	get_parent().add_child(target)
	target.set_global_position(location)
	state = STATE.move


func attack(entity : Node2D):
	target = entity
	state = STATE.fight


func idle():
	target = null
	state = STATE.idle


func select(enable : bool):
	selected = enable
	if selected:
		_on_mouse_entered()
	else:
		_on_mouse_exited()


func control(enable : bool):
	friend = enable

	if not friend:
		if is_in_group("troops"):
			remove_from_group("troops")
		add_to_group("enemies")

		$Health/Bar.set_progress_texture(enemy_texture)

		$Selection.set_modulate(Color.red)
		$Selection.set_z_index(0)

	else:
		if is_in_group("enemies"):
			remove_from_group("enemies")
		add_to_group("troops")

		$Health/Bar.set_progress_texture(friendly_texture)

		$Selection.set_modulate(Color.green)
		$Selection.set_z_index(-1)


func die():
	# @TODO: signal death to followers & commander
	idle()
	select(false)

	if friend:
		.die() #YouOnlyUndieOnce
	else:
		set_modulate(Color.black)


func reanimate():
	update_health(health_max) # @NOTE: revive with partial health (?)
	control(true)

	set_modulate(Color.white)

	$SoundFX/Reanimate.play()


func update_health(delta):
	.update_health(delta)
	$Health/Bar.show()


func _on_attack_conected(body):
	if self.is_in_group("troops") and body.is_in_group("troops"):
		return
	elif self.is_in_group("enemies") and body.is_in_group("enemies"):
		return

	._on_attack_conected(body)


func _ready():
	control(self.friend)


func _control(delta):
	match state:
		STATE.move:
			_move()
		STATE.fight:
			_fight()
		STATE.idle:
			_idle()


func _move():
	var dir = target.get_global_position() - self.get_global_position()
	# @TODO: better unit formation when reaching target location
	if dir.length() > SAFE_MARGIN:
		# @TODO: pathfind towards target
		velocity = dir.normalized() * speed
	else:
		idle()


func _fight():
	# @TODO: lose sight of target through fog of war
	if target == null or target.is_dead():
		idle()
		return

	var dir = target.get_global_position() - self.get_global_position()
	if dir.length() <= BODY_OFFSET + attack_range:
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
