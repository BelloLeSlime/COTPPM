extends StaticBody2D

const speed = 3
signal move_finished

func go_up_hidden(n: int = 100):
	$AnimatedSprite2D.play("walk up hidden")
	for i in range(n):
		position.y -= speed
		await get_tree().process_frame
	$AnimatedSprite2D.play("idle up hidden")
	emit_signal("move_finished")

func show_levier():
	$AnimatedSprite2D.play("idle up")

func go_down_and_pop(n: int = 100):
	$AnimatedSprite2D.play("walk down")
	for i in range(n):
		position.y += speed
		await get_tree().process_frame
	emit_signal("move_finished")
	queue_free()

