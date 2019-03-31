extends KinematicBody2D


export var speed := 100
const ZERO := Vector2(0, 0)
var velocity := ZERO

export var health_max : int = 100
onready var health := health_max

export var attack_range : float = 32.0
export var attack_damage : int = 20
export var attacks_per_second : float = 0.5
const BODY_OFFSET : float = 45.2548339959
const SAFE_MARGIN := 5


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

	if velocity.length() > SAFE_MARGIN and not $SoundFX/Step.is_playing():
		$SoundFX/Step.play()
	elif velocity.length() <= SAFE_MARGIN:
		$SoundFX/Step.stop()

	velocity = move_and_slide(velocity)
