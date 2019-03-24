extends Node2D

var mouse

class mouse_functions:
	func go_to_player():
		#retornar ao jogador quando uma tecla eh apertada
		pass

func _ready():
	mouse = mouse_functions

func _process(delta):
	position = get_global_mouse_position()