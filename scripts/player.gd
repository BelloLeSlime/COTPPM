extends CharacterBody2D

const speed = 300
@export var map_open: bool = false
@export var first_map_open: bool = true
var direction = "down"
var moving = "idle"
var input_vector = Vector2.ZERO

func _ready():
	input_vector.x = 0
	input_vector.y = 1
	input_vector = input_vector.normalized()

func _physics_process(_delta):
	
	if Globals.can_play:
		input_vector = Vector2.ZERO
		input_vector.x = Input.get_action_strength("d") - Input.get_action_strength("q")
		input_vector.y = Input.get_action_strength("s") - Input.get_action_strength("z")
		input_vector = input_vector.normalized()
		
		if abs(input_vector.x) > 0 or abs(input_vector.y) > 0:
			moving = "walk"
			if abs(input_vector.x) > 0:
				if input_vector.x > 0:
					direction = "right"
				elif input_vector.x < 0:
					direction = "left"
			elif abs(input_vector.y) > 0:
				if input_vector.y > 0:
					direction = "down"
				elif input_vector.y < 0:
						direction = "up"
		else:
			moving = "idle"
	else:
		moving = "idle"
	
	if not map_open:
		$AnimatedSprite2D.play(moving + "_" + direction)
	else:
		$AnimatedSprite2D.play("map")
	
	if Globals.can_play:
		velocity = input_vector * speed
		move_and_slide()

func _input(event):
	if event.is_action_pressed("tab") and (Globals.can_play or map_open):
		if not map_open:
			open_map()
		else:
			close_map()

func open_map():
	map_open = true
	Globals.can_play = false
	$Camera2D.zoom = Vector2(0.5, 0.5)
	direction = "down"
	
	if first_map_open:
		Dialog.show_dialog(7)
		first_map_open = false
		await Dialog.dialog_finished
		Globals.can_play = false

func close_map():
	map_open = false
	Globals.can_play = true
	$Camera2D.zoom = Vector2(1, 1)
