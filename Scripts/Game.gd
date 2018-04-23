extends Node2D

onready var TurnManager = get_node("TurnManager")
onready var RankManager = get_node("RankManager")
onready var players = get_node("Players")

var pressed = false

func _ready():
	randomize()
	players.get_node("Hands").hide()
	get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_2D, SceneTree.STRETCH_ASPECT_KEEP, Vector2(400, 640))
	pass

func _process(delta):
	if not players.get_node("Hands").your_turn:
		get_node("Pass").hide()
	else:
		players.get_node("Hands").show()
		get_node("Pass").show()
	if Input.is_action_just_pressed("pass"):
		pressed = true
	if players.get_node("Hands").your_turn and pressed:
		TurnManager.next_turn()
		players.get_node("Hands").your_turn = false
		pressed = false
#		get_node("PlayCard").hide()
		pass
#	if TurnManager.is_your_turn():
#		players.get_node("Hands").your_turn = true
#	else:
#		players.get_node("Hands").your_turn = false
	
	pass

#func _notification(what):
#	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
#		for v in get_node("Players/Hands/").item_scene.values():
#			v.queue_free()
#		get_tree().quit() # default behavior
