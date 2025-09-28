extends Node2D

@export var player_path: NodePath
@export var fade_layer_path: NodePath
var first_out = false


var coor = {
	"RDCto1ST" : Vector2(4896, 720),
	"1STtoRDC" : Vector2(1376, 68),
	"1STtoBED" : Vector2(3980, -1405),
	"BEDto1ST" : Vector2(5410, 523),
	"RDCtoOUT" : Vector2(13424, 681),
	"OUTtoRDC" : Vector2(1401, 607)
	
}

func _ready():
	var player = get_node(player_path)
	var fade = get_node(fade_layer_path)
	
	for child in get_children():
		if child is Area2D:
			child.body_entered.connect(func(body):
				_on_area_body_entered(child, body, player, fade))

func _on_area_body_entered(area: Area2D, body: Node, player: Node, fade: Node):
	if body == player:
		var name = area.name
		if coor.has(name):
			teleport(player, fade, coor[name])
			if name == "RDCtoOUT" and first_out == false:
				$Timer.start()
				await $Timer.timeout
				Dialog.show_dialog(8)
				Globals.can_play = false
				await Dialog.dialog_finished
				Dialog.show_dialog(9)
				await Dialog.dialog_finished
				Dialog.show_dialog(10)
				await Dialog.dialog_finished
				Dialog.show_dialog(11)
				first_out = true
		else:
			push_warning("Pas de coordonnées définies pour %s" % name)

func teleport(player: Node, fade: Node, target: Vector2):
	Globals.can_play = false
	await fade.fade_in(0.5)
	player.global_position = target
	await fade.fade_out(0.5)
	Globals.can_play = true
