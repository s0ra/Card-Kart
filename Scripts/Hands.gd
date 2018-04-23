extends Node2D

onready var game = get_parent().get_parent()
onready var deck = get_parent().get_parent().get_node("Deck")
onready var TurnManager = get_parent().get_parent().get_node("TurnManager")

var player_id = 0
var rank = 0

var your_turn = false
var played = false
var discarded = false
var can_end = false
var playing = false

var play = ""
var discards = 0

var hands = []
var A1 = "accel1"
var A2 = "accel2"
var A3 = "accel3"
var OL = "oil_leak"
var B = "f-bomb"
var P = "protection"

var item_turbo = Item.item_turbo
var item_f = Item.item_f

var item_scene = { "": preload("res://Scenes/Hand.tscn").instance(),
				   "accel1": preload("res://Scenes/Accel1.tscn").instance(),
				   "accel2": preload("res://Scenes/Accel2.tscn").instance(),
				   "accel3": preload("res://Scenes/Accel3.tscn").instance(),
				   "oil_leak": preload("res://Scenes/OL.tscn").instance(),
				   "f-bomb": preload("res://Scenes/F-bomb.tscn").instance(),
				   "protection": preload("res://Scenes/Protect.tscn").instance()
				 }

func _ready():
	pass

func setup():
	var id = 1
	for hand in get_children():
		add_child(item_scene[hands[id-1]].duplicate())
		get_children().back().position = hand.position
		get_children().back().set_name("Hand" + str(id))
		print(get_children().back().get_name())
		hand.queue_free()
		if get_children().back().has_node("TouchScreenButton"):
			get_children().back().get_node("TouchScreenButton").action = "card" + str(id)
		id += 1

func _process(delta):
	if your_turn:
		for id in range(1, 5):
			manage_hand(id)
	if your_turn and playing:
		game.get_node("PlayCard").rotation = 0
		var position = get_global_mouse_position()
		game.get_node("PlayCard").position = position
		game.get_node("PlayCard").visible = true
		game.get_node("Pass").hide()
	if your_turn and not playing:
		game.get_node("Pass").show()
		game.get_node("PlayCard").visible = false
		for hand in get_children():
			hand.modulate = Color(1, 1, 1, 1)
	elif not your_turn:
		for hand in get_children():
			hand.modulate = Color(1, 1, 1, 0.5)
	if discarded or played:
		can_end = true
	pass

func your_turn():
	draw()
	print(true)
	your_turn = true

func draw():
	for i in range(4-hands.size()):
		hands.append(deck.draw())
	pass

func play(type):
	play = type
	game.get_node("Ranking/Rank"+str(rank)).get_data().item = item_f[type]
	game.get_node("CardAnimation").play("Play")
	

func discard():
	game.get_node("CardAnimation").play("Discard")
	discards += 1
	game.get_node("Ranking/Rank"+str(rank)).get_data().speed += 1
	TurnManager.change(rank)
#	game.get_node("TurnAnimation").play("change_"+str(rank))

func start_turn():
	TurnManager.congra()
	play = ""
	discards = 0
	for player in game.get_node("Ranking").get_children():
		if player.get_data().player_id == player_id:
			rank = player.rank
	your_turn()
	setup()

func end_turn():
	
	pass

func manage_hand(id):
	var _id = str(id)
	if Input.is_action_just_pressed("card"+_id):
		game.get_node("Pass").hide()
		game.get_node("Discard").show()
		get_children()[id-1].modulate = Color(1, 1, 1, 0.3)
#		get_node("Hand"+_id).modulate = Color(1, 1, 1, 0.3)
		playing = true
	elif Input.is_action_just_released("card"+_id):
		if get_global_mouse_position().y < 350 and play == "" and game.get_node("Ranking/Rank"+str(rank)).get_data().turbo >= item_turbo[get_children()[id-1].type]:
			get_children()[id-1].hide()
			play(get_children()[id-1].type)
			hands.erase(get_children()[id-1].type)
		elif get_global_mouse_position().y < 350 and play == "":
			game.get_node("TurnAnimation").play("NoTurbo")
		elif get_global_mouse_position().y > 600 and discards < 3:
			get_children()[id-1].hide()
			discard()
			hands.erase(get_children()[id-1].type)
		playing = false
		game.get_node("Pass").show()
		game.get_node("Discard").hide()
		get_children()[id-1].modulate = Color(1, 1, 1, 0.3)

func _exit_tree():
	for c in get_children():
		c.free()
	for v in item_scene.values():
		v.free()
	pass