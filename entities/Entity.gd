extends KinematicBody2D


const ZERO := Vector2(0, 0)
export var speed : int = 100
var velocity : Vector2 = ZERO


func _physics_process(delta):
	control(delta)
	velocity = move_and_slide(velocity)

func control(delta):
	# update velocity
	pass
