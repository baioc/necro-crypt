extends "res://entities/Entity.gd"


func _control(delta):
	velocity = ZERO

	if anim_lock:
		return

	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x += -1
	if Input.is_action_pressed("ui_up"):
		velocity.y += -1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1

	velocity = velocity.normalized() * speed


func _on_animation_finished():
	if $Sprite.get_animation().begins_with("spellcast"):
		anim_lock = false
	._on_animation_finished()


func _on_spellcast():
	if facing_right:
		$Sprite.play("spellcast_right")
	else:
		$Sprite.play("spellcast_left")

	anim_lock = true
