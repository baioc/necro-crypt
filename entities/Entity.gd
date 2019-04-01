extends KinematicBody2D


export var speed := 100
const ZERO := Vector2(0, 0)
var velocity := ZERO

export var health_max : int = 100
onready var health := health_max

export var attack_damage : int = 20
export var attacks_per_second : float = 0.5
export var attack_range : float = 18
const BODY_OFFSET : float = 36.87
const SAFE_MARGIN := 3.0

var facing_right := true
var anim_lock := false


func is_dead() -> bool:
	return health <= 0


func update_health(delta, source : Node2D = null):
	if delta <= 0:
		$Health/Delta.set_text(str(-delta))
		$SoundFX/Hit.play()
	else:
		$Health/Delta.set_text("+" + str(delta))
	$Health/Animator.play("health_change")

	health = clamp(health + delta, 0, health_max) as int
	$Health/Bar.value = health

	if is_dead():
		$SoundFX/Death.play()
		$Sprite.play("dead")
		die()
		return
	else:
		$Animator.play("blink")


func die():
	"""Perform any needed actions before destruction"""
	queue_free()
	pass


func _control(delta):
	"""Control Entity movement through velocity Vector"""
	pass


func _hit(dir : Vector2):
	"""Perform attack in specified direction"""
	if not $Attack/Timer.is_stopped():
		return

	if facing_right:
		$Sprite.play("attack_right")
	else:
		$Sprite.play("attack_left")

	anim_lock = true

	$Attack.set_position(dir.normalized() * attack_range)
	$Attack.set_rotation(dir.angle())

	$Attack.set_monitoring(true)
	$Attack/Timer.start()


func _on_attack_done():
	$Attack.set_monitoring(false)


func _on_attack_conected(body):
	if self == body:
		return
	elif body.has_method("update_health") and not body.is_dead():
		body.update_health(-attack_damage, self)


func _ready():
	$Health/Bar.max_value = health_max
	$Health/Bar.value = health

	$Attack/Timer.set_wait_time(1 / attacks_per_second)


func _physics_process(delta):
	_control(delta)
	velocity = move_and_slide(velocity)

	if is_dead():
		return

	if velocity.length() > SAFE_MARGIN and not $SoundFX/Step.is_playing():
		$SoundFX/Step.play()
	elif velocity.length() <= SAFE_MARGIN:
		$SoundFX/Step.stop()

	if anim_lock:
		return

	if velocity.length() > 0:
		if velocity.x > 0 or (velocity.x == 0 and facing_right):
			facing_right = true
			$Sprite.play("walk_right")
		elif velocity.x < 0 or (velocity.x == 0 and not facing_right):
			facing_right = false
			$Sprite.play("walk_left")
	else:
		if facing_right:
			$Sprite.play("idle_right")
		else:
			$Sprite.play("idle_left")


func _on_animation_finished():
	if $Sprite.get_animation().begins_with("attack") or $Sprite.get_animation().begins_with("reanimate"):
		anim_lock = false
