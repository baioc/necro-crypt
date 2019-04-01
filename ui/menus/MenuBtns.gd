extends Control


func _on_PlayBtn_pressed():
	get_tree().change_scene("res://map/levels/World.tscn")


func _on_TutorialBtn_pressed():
	get_tree().change_scene("res://map/levels/Tutorial.tscn")


func _on_MenuBtn_pressed():
	get_tree().change_scene("res://ui/menus/MainMenu.tscn")


func _on_ExitBtn_pressed():
	get_tree().quit()
