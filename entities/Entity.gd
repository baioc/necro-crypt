extends KinematicBody2D


export var speed := 100
const ZERO := Vector2(0, 0)
var velocity := ZERO

signal health_changed
export var health_max : int = 100
var health := health_max

export var attack_range := 35.0


func is_dead() -> bool:
	return health <= 0

func health_update(delta):
	emit_signal("health_changed", delta)
	health = clamp(health + delta, 0, health_max)
	if is_dead():
		die()

func die():
	queue_free()

func _control(delta):
	# Control movement through velocity
	pass

func _hit(dir : Vector2):
	# @TODO: Attack
	pass

func _physics_process(delta):
	_control(delta)
	velocity = move_and_slide(velocity)
