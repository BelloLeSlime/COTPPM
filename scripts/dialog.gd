extends CanvasLayer

@onready var text_label: Label = $Panel/Text
signal dialog_finished

var dialog =[
	[
		"BELLO !!!!",
		"Oui Boing ?",
		"Viens dans la cuisine !"
	],
	[
		"Qu'est ce qu'il y a ?"
	],
	[
		"Le frigo est vide !",
		"Et ?",
		"J'ai faim, va acheter à manger !",
		"Je veux bien mais on a plus d'argent, on a littéralement 0 Flambcoin.",
		"Va chercher un taf et rapporte l'argent à la maison !",
		"D'accord...",
		"* Objectifs mis à jour !
		-Aller dehors
		-Trouver un taf
		-Rembourser Ceraris",
		"Hey, pourquoi je dois rembourser Ceraris déjà ?",
		"Pour son service spécial imbécile."
	],
	[
		"C'est énorme !",
		"Ça va jamais rentrer !",
		"Je sais que c'est super gros mais ça doit passer."
	],
	[
		"Quel service ?"
	],
	[
		"Bah faire rentrer le canapé dans la maison."
	],
	[
		"Bref, va dehors.",
		"* Appuyez sur TAB pour ouvrir la carte."
		
	],
	[
		"Bruh tu as vraiment besoin de la carte pour marcher dans ta maison ?",
		"Oui je suis smart."
	],
	[
		"Ah donc l'entrée est VRAIMENT pétée.",
		"En plus d'être un internal plexus..."
	],
	[
		"BELLO !!!"
	],
	[
		"Oui c'est moi, mais t'es qui déjà ?",
		"Tu as déjà oublié ton plus GRAND rival ?!",
		"Moi je m'appelle..."
	],
	[
		"Levier..."
	]
]

var character = [
	[
		"???",
		"Bello",
		"Boing"
	],
	[
		"Bello"
	],
	[
		"Boing",
		"Bello",
		"Boing",
		"Bello",
		"Boing",
		"Bello",
		"",
		"Bello",
		"Boing"
	],
	[
		"Ceraris",
		"Bello",
		"Ceraris"
	],
	[
		"Bello"
	],
	[
		"Boing"
	],
	[
		"Boing",
		""
	],
	[
		"Boing",
		"Bello"
	],
	[
		"Bello",
		"Bello"
	],
	[
		"???"
	],
	[
		"Bello",
		"???",
		"???"
	],
	[
		"Levier"
	]
]

var expressions = [
	[
		"Boing/hidden.png",
		"Bello/normal.png",
		"Boing/hidden.png"
	],
	[
		"Bello/normal.png"
	],
	[
		"Boing/angry.png",
		"Bello/question.png",
		"Boing/cry.png",
		"Bello/not_happy.png",
		"Boing/nerve.png",
		"Bello/sweat.png",
		"none",
		"Bello/normal.png",
		"Boing/normal.png"
	],
	[
		"Ceraris/hidden.png",
		"Bello/hidden.png",
		"Ceraris/hidden.png"
	],
	[
		"Bello/question.png"
	],
	[
		"Boing/normal.png"
	],
	[
		"Boing/angry.png",
		"none"
	],
	[
		"Boing/bruh.png",
		"Bello/normal.png"
	],
	[
		"Bello/not_happy.png",
		"Bello/sweat.png"
	],
	[
		"Levier/hidden.png"
	],
	[
		"Bello/question.png",
		"Levier/hidden_nerve.png",
		"Levier/hidden.png"
	],
	[
		"Levier/normal.png"
	]
]

var sounds = [
	[
		"boing.ogg",
		"bello.ogg",
		"boing.ogg"
	],
	[
		"bello.ogg"
	],
	[
		"boing.ogg",
		"bello.ogg",
		"boing.ogg",
		"bello.ogg",
		"boing.ogg",
		"bello.ogg",
		"narrator.ogg",
		"bello.ogg",
		"boing.ogg"
	],
	[
		"ceraris.ogg",
		"bello.ogg",
		"ceraris.ogg"
	],
	[
		"bello.ogg"
	],
	[
		"boing.ogg"
	],
	[
		"boing.ogg",
		"narrator.ogg"
	],
	[
		"boing.ogg",
		"bello.ogg"
	],
	[
		"bello.ogg",
		"bello.ogg"
	],
	[
		"levier.ogg"
	],
	[
		"bello.ogg",
		"levier.ogg",
		"levier.ogg"
	],
	[
		"levier.ogg"
	]
]

@onready var sfx: AudioStreamPlayer = $sound
var is_in_dialog = false
var current_message: int = 0
var char_index: int = 0
var typing_speed: float = 0.03
var is_typing: bool = false
var typing_timer: float = 0.0

func show_message(message):
	current_message = message
	Globals.can_play = false
	char_index = 0
	text_label.text = ""
	show()
	is_typing = true
	typing_timer = typing_speed
	$Char/Text.text = character[Globals.dialog_index][current_message]
	var char_path: String = "res://assets/characters/" + expressions[Globals.dialog_index][current_message]
	$CharIcon.texture = load(char_path)

func show_dialog(dialog_index):
	is_in_dialog = true
	current_message = 0
	Globals.dialog_index = dialog_index
	show_message(current_message)

func play_sound():
	var sound_path = "res://assets/sounds/character/" + sounds[Globals.dialog_index][current_message]
	sfx.stream = load(sound_path)
	sfx.play()

func _process(delta):
	if is_typing:
		typing_timer -= delta
		if typing_timer <= 0.0 and char_index < dialog[Globals.dialog_index][current_message].length():
			typing_timer = typing_speed
			char_index += 1
			text_label.text = dialog[Globals.dialog_index][current_message].substr(0, char_index)
			if not dialog[Globals.dialog_index][current_message][char_index - 1] in [" ", ".", ",", "!", "?"]:
				play_sound()
		elif char_index >= dialog[Globals.dialog_index][current_message].length():
			is_typing = false

func _input(event: InputEvent) -> void:
	if is_in_dialog:
		if event.is_action_pressed("ui_accept"): # espace/entrée par défaut
			if is_typing:
				# Finir d’un coup si on appuie pendant l’écriture
				text_label.text = dialog[Globals.dialog_index][current_message]
				is_typing = false
			else:
				# Passer au message suivant
				if current_message+1 < dialog[Globals.dialog_index].size():
					show_message(current_message+1)
				else:
					hide()
					char_index = 0
					current_message = 0
					Globals.can_play = true
					is_in_dialog = false
					emit_signal("dialog_finished")
