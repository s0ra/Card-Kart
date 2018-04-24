extends Node

onready var game = get_parent().get_parent()
onready var deck = game.get_node("Deck")
onready var TurnAnimation = get_parent().get_parent().get_node("TurnAnimation")
onready var TurnManager = get_parent().get_parent().get_node("TurnManager")
var ranking

var player_id = 0
var rank = 0
var ai_id = 0

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

var item_f = Item.item_f

var item_turbo = Item.item_turbo

func _ready():
	pass

func start_turn():
	play = ""
	discards = 0
	for player in game.get_node("Ranking").get_children():
		if player.get_data().player_id == player_id:
			rank = player.rank
			ranking = player
	your_turn()

func your_turn():
	draw()
	your_turn = true
	if your_turn:
		think(true)
#		yield(TurnAnimation, "animation_finished")
		var card = ""
		for c in range(hands.size()):
			if ranking.get_data().turbo >= item_turbo[hands[c]]:
				if hands[c] == P and rank < 3:
					card = hands[c]
					break
				elif hands[c] == OL and rank < 3:
					card = hands[c]
					break
				elif hands[c] == B and rank > 1:
					card = hands[c]
					break
				elif hands[c] != P and hands[c] != OL and hands[c] != B:
					card = hands[c]
					break
		if card != "":
			TurnAnimation.play("ShowItem")
			yield(TurnAnimation, "animation_finished")
			pre_play()
			yield(game.get_node("CardAnimation"), "animation_finished")
			play(card)
			TurnAnimation.play("ShowItem")
			yield(TurnAnimation, "animation_finished")
			var i = randi() % 5
			if i <= 3:
				for d in range(i):
					pre_discard()
					discard(hands[0])
					yield(TurnAnimation, "animation_finished")
					yield(game.get_node("CardAnimation"), "animation_finished")
					TurnAnimation.play("ShowItem")
					yield(TurnAnimation, "animation_finished")
		else:
			pre_discard()
			discard(hands[0])
			yield(TurnAnimation, "animation_finished")
			yield(game.get_node("CardAnimation"), "animation_finished")
			var i = randi() % 5
			if i <= 2:
				for d in range(i):
					pre_discard()
					discard(hands[0])
					yield(TurnAnimation, "animation_finished")
					yield(game.get_node("CardAnimation"), "animation_finished")
					
		your_turn = false
		TurnManager.next_turn()

func draw():
	for i in range(4-hands.size()):
		var draw = deck.draw()
		if draw != "":
			hands.append(draw)
#	print(hands)
	pass

func think(long=false):
	if long:
#		TurnAnimation.play("long_think")
		pass
	else:
#		TurnAnimation.play("short_think")
		pass
#	yield(TurnAnimation, "animation_finished")
	pass

func pre_play():
#	game.get_node("PlayCard").show()
	game.get_node("CardAnimation").play("AI" + str(ai_id) + "_play")
	pass

func play(type):
	play = type
	hands.erase(type)
	game.get_node("Ranking/Rank"+str(rank)).get_data().item = item_f[type]
#	game.get_node("CardAnimation").play("AI" + str(ai_id) + "_play")
#	yield(TurnAnimation, "animation_finished")
#	game.get_node("CardAnimation").play("Play")
#	yield(game.get_node("CardAnimation"), "animation_finished")

func discard(type):
	hands.erase(type)
	discards += 1
	game.get_node("Ranking/Rank"+str(rank)).get_data().speed += 1

func pre_discard():
	TurnManager.change(rank)
	game.get_node("CardAnimation").play("Discard")
#	game.get_node("TurnAnimation").play("change_"+str(rank))

func _process(delta):
	pass
