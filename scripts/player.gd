extends CharacterBody2D

const speed = 300
@export var map_open: bool = false
@export var first_map_open: bool = true
 
func _ready():
	$AnimatedSprite2D.play("down")

func _physics_process(_delta):
	
	if Globals.can_play:
		var input_vector = Vector2.ZERO

		# Récupère les touches pressées (ZQSD ou flèches)
		input_vector.x = Input.get_action_strength("d") - Input.get_action_strength("q")
		input_vector.y = Input.get_action_strength("s") - Input.get_action_strength("z")

		# Normalise pour éviter d'aller plus vite en diagonale
		input_vector = input_vector.normalized()
		
		if abs(input_vector.x) > abs(input_vector.y):
			if input_vector.x > 0:
				$AnimatedSprite2D.play("right")
			elif input_vector.x < 0:
				$AnimatedSprite2D.play("left")
		else:
			if input_vector.y > 0:
				$AnimatedSprite2D.play("down")
			elif input_vector.y < 0:
				$AnimatedSprite2D.play("up")

		# Déplace le joueur
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
	$AnimatedSprite2D.play("map")
	
	if first_map_open:
		Dialog.show_dialog(7)
		first_map_open = false
		await Dialog.dialog_finished
		Globals.can_play = false

func close_map():
	map_open = false
	Globals.can_play = true
	$Camera2D.zoom = Vector2(1, 1)
	$AnimatedSprite2D.play("down")


