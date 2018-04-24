extends Node

var deck = []

var A1 = "accel1"
var A2 = "accel2"
var A3 = "accel3"
var OL = "oil_leak"
var B = "f-bomb"
var P = "protection"

func _ready():
	for i in range(15):
		deck.append(A1)
	for i in range(10):
		deck.append(A2)
	for i in range(10):
		deck.append(A3)
	for i in range(10):
		deck.append(OL)
	for i in range(10):
		deck.append(B)
	for i in range(5):
		deck.append(P)
	shuffle()
	pass

func draw():
	if deck_size() > 0:
		return deck.pop_back()
	else:
		get_parent().get_node("TurnManager").congra()
		return ""

func _process(delta):
	get_parent().get_node("DeckRemain").text = "Deck Remains: " + str(deck_size())

func deck_size():
	return deck.size()

func shuffle():
	randomize()
	if !deck.empty():
		var size = deck.size()
		var remain = size
		for i in range(size):
			var j = randi() % remain
			deck.append(deck[j])
			deck.remove(j)
			remain -= 1
