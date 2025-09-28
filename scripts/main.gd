extends Node2D

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Dialog.show_dialog(0)

func _input(_event):
	if Input.is_action_just_pressed("quit_game"):
		get_tree().quit()
