extends "res://entities/Entity.gd"


export var friend : bool = false
export var friendly_texture : Texture
export var enemy_texture : Texture
var selected : bool = false

enum STATE { idle, move, fight }
var state = STATE.idle
var target : WeakRef = null


func goto(location : Vector2):
	var container = Node2D.new()
	get_parent().add_child(container)
	container.set_global_position(location)

	target = weakref(container)
	state = STATE.move


func attack(entity : Node2D):
	target = weakref(entity)
	state = STATE.fight


func idle():
	target = null
	state = STATE.idle


func is_idle() -> bool:
	return state == STATE.idle


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


func reanimate():
	idle()
	update_health(health_max) # @NOTE: revive with partial health (?)
	control(true)

	$SoundFX/Reanimate.play()

	$Sprite.play("reanimate")
	anim_lock = true


func die():
	if friend:
		.die() #YouOnlyUndieOnce
	else:
		$Selection.set_modulate(Color.green)
		$Selection.set_z_index(-1)


func update_health(delta, source : Node2D = null):
	if delta < 0:
		$Health/Bar.show()

		if source != null:
			attack(source)

	.update_health(delta)


func _on_attack_conected(body):
	if self.is_in_group("troops") and body.is_in_group("troops"):
		return
	elif self.is_in_group("enemies") and body.is_in_group("enemies"):
		return

	._on_attack_conected(body)


func _ready():
	control(self.friend)


func _control(delta):
	if is_dead():
		_idle()
		return

	match state:
		STATE.move:
			_move()
		STATE.fight:
			_fight()
		STATE.idle:
			_idle()


func _move():
	var dir = target.get_ref().get_global_position() - self.get_global_position()
	# @TODO: better unit formation when reaching target location
	if dir.length() > SAFE_MARGIN:
		# @TODO: pathfind towards target (add navigation visual indicator)
		velocity = dir.normalized() * speed
	else:
		idle()


func _fight():
	# @TODO: lose sight of target through fog of war
	if target == null or !target.get_ref() or target.get_ref().is_dead():
		idle()
		return

	var dir = target.get_ref().get_global_position() - self.get_global_position()
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
