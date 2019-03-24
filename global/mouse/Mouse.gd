extends Node2D

onready var player = get_tree().get_root().get_node("World/Player")
onready var camera = get_tree().get_root().get_node("World/Mouse/Camera")
var timer = Timer.new()

var mouse_states = {"on_player": 0, "free": 1, "goto_player": 2}
var current_state

func input():
	if Input.is_action_just_pressed("ui_goto_player"):
		timer_start()
		current_state = mouse_states["goto_player"]
	if Input.is_action_just_pressed("ui_follows_player"):
		if current_state == mouse_states["on_player"]:
			current_state = mouse_states["free"]
		else:
			current_state = mouse_states["on_player"]
func goto_player():
	position = player.get_position()
	camera.align()

func free_mouse():
	position = get_global_mouse_position()

func on_player():
	position = player.get_position()
	camera.align()

func _ready():
	current_state = mouse_states["free"]
	timer_proprities()

func _process(delta):
	input()
	control(delta)

func control(delta):
	if current_state == 0:
		on_player()
	elif current_state == 1:
		free_mouse()
	elif current_state == 2:
		goto_player()
		timer_free()

func timer_proprities():
	timer.set_wait_time(0.4)
	timer.set_one_shot(true)
	self.add_child(timer)

func timer_start():
	timer.start()
	yield(timer,"timeout")

func timer_free():
	if timer.is_stopped():
		current_state = mouse_states["free"]
