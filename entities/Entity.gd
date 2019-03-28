extends KinematicBody2D


export var speed := 100
const ZERO := Vector2(0, 0)
var velocity := ZERO

export var health_max : int = 100
onready var health := health_max

export var attack_range := 35.0


func is_dead() -> bool:
	return health <= 0


func update_health(delta):
	health = clamp(health + delta, 0, health_max) as int
	if is_dead():
		die()


func die():
	"""Perform any needed actions before freeing"""
	queue_free()
	pass


func _control(delta):
	"""Control Entity movement through velocity Vector"""
	pass


func _hit(dir : Vector2):
	"""@TODO: Perform an attack in specified direction"""
	pass


func _physics_process(delta):
	_control(delta)
	velocity = move_and_slide(velocity)
