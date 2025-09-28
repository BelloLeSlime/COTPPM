extends StaticBody2D

func _ready():
	$AnimatedSprite2D.play("idle")

func _on_dialog_body_entered(body):
	if body.name == "Player":
		Dialog.show_dialog(1)
		await Dialog.dialog_finished
		$AnimatedSprite2D.play("open_fridge")
		await $AnimatedSprite2D.frame == 2
		
		await $AnimatedSprite2D.frame == 0
		$AnimatedSprite2D.play("idle")
		
		$Dialog.queue_free()
		Dialog.show_dialog(2)
		await Dialog.dialog_finished
		Dialog.show_dialog(3)
		await Dialog.dialog_finished
		Dialog.show_dialog(4)
		await Dialog.dialog_finished
		Dialog.show_dialog(5)
		await Dialog.dialog_finished
		Dialog.show_dialog(6)
		await Dialog.dialog_finished
