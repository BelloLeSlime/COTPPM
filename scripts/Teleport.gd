extends Node2D

signal teleport_finished

@export var player_path: NodePath
var first_out = false
var levier_preload = preload("res://scenes/levier.tscn")
var levier


var coor = {
	"RDCto1ST" : Vector2(4896, 720),
	"1STtoRDC" : Vector2(1376, 68),
	"1STtoBED" : Vector2(3980, -1405),
	"BEDto1ST" : Vector2(5410, 523),
	"RDCtoOUT" : Vector2(13424, 681),
	"OUTtoRDC" : Vector2(1401, 607),
	"1STtoBAT" : Vector2(891, -1898),
	"BATto1ST" : Vector2(4870, 404) ,
	"1STtoBOI" : Vector2(2342, 1895),
	"BOIto1ST" : Vector2(4321, 524)
}

func _ready():
	var player = get_node(player_path)
	var fade = ScreenFade
	levier = levier_preload.instantiate()
	add_child(levier)
	levier.position = Vector2(13424, 977)
	
	for child in get_children():
		if child is Area2D:
			child.body_entered.connect(func(body):
				_on_area_body_entered(child, body, player, fade))

func _on_area_body_entered(area: Area2D, body: Node, player: Node, fade: Node):
	if body == player:
		@warning_ignore("shadowed_variable_base_class")
		var name = area.name
		if coor.has(name):
			teleport(player, fade, coor[name])
			if name == "RDCtoOUT" and first_out == false:
				await teleport_finished
				
				Dialog.show_dialog(8)
				Globals.can_play = false
				await Dialog.dialog_finished
				
				Dialog.show_dialog(9)
				await Dialog.dialog_finished
				Globals.can_play = false
				levier.go_up_hidden(70)
				await levier.move_finished
				
				Dialog.show_dialog(10)
				await Dialog.dialog_finished
				levier.show_levier()
				
				Dialog.show_dialog(11)
				await Dialog.dialog_finished
				Globals.can_play = false
				levier.go_down_and_pop(100)
				Globals.can_play = true
				first_out = true
		else:
			push_warning("Pas de coordonnées définies pour %s" % name)

func teleport(player: Node, fade: Node, target: Vector2):
	Globals.can_play = false
	await fade.fade_in(0.5)
	player.global_position = target
	await fade.fade_out(0.5)
	Globals.can_play = true
	emit_signal("teleport_finished")
