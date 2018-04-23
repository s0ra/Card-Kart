extends Node

onready var AIManager1 = get_parent().get_node("Players/AIManager1")
onready var AIManager2 = get_parent().get_node("Players/AIManager2")
onready var AIManager3 = get_parent().get_node("Players/AIManager3")
onready var parent = get_parent()

onready var deck = parent.get_node("Deck")
onready var players = parent.get_node("Players")
onready var ranking = parent.get_node("Ranking")
onready var TurnAnimation = parent.get_node("TurnAnimation")
onready var RankManager = parent.get_node("RankManager")
onready var RankAnimation = parent.get_node("RankAnimation")

var total_players = 4

var turn = 0
#var player_turn = 2
var player_id = 1

var end_game = false

var rank_card = {}

var A1 = "accel1"
var A2 = "accel2"
var A3 = "accel3"
var OL = "oil_leak"
var B = "f-bomb"
var P = "protection"

var item = 1
var item_f = Item.item_f

var item_speed = Item.item_speed

var item_turbo = Item.item_turbo

func _ready():
	parent.get_node("Players/AIManager1").ai_id = 1
	parent.get_node("Players/AIManager2").ai_id = 2
	parent.get_node("Players/AIManager3").ai_id = 3
#	print(turn)
	start_all()
	for n in ranking.get_children():
		turbo(n.rank)
		n.get_data().turbo += 2
		yield(TurnAnimation, "animation_finished")
	parent.get_node("Players/AIManager1").start_turn()

func next_turn():
	congra()
	if end_game:
		return
#	for player in parent.get_node("Players").get_children():
#		if player.rank == turn:
	var player = get_player()
	rank_card[player.rank] = player.play
#	print(rank_card)
	turn += 1
#	print(turn)
	if turn == total_players:
#		parent.get_node("TurnAnimation").play("end_all")
		# UNTESTED
		var oil = 5
		var bomb = 0
		for c in range(1,5):
			if rank_card[c] == "":
				pass
			else:
				var data = ranking.get_node("Rank"+str(c)).get_data()
				ranking.get_node("Rank"+str(c)).show_item = true
				TurnAnimation.play("ShowItem")
				yield(TurnAnimation, "animation_finished")
				data.item = item_f[rank_card[c]]
				if rank_card[c] == OL and oil == 5:
					oil = c
				elif rank_card[c] == B:
					bomb += 1
				elif rank_card[c] == P:
					data.protection = true
				if rank_card[c] == P:
					var turbo = data.turbo
					data.turbo = 0
					turbo(c, turbo, false)
					yield(TurnAnimation, "animation_finished")
				else:
					data.turbo -= item_turbo[rank_card[c]]
					turbo(c, item_turbo[rank_card[c]], false)
					yield(TurnAnimation, "animation_finished")
				if rank_card[c] == A2 or rank_card[c] == A3:
					data.turbo += 1
					turbo(c, 1)
					yield(TurnAnimation, "animation_finished")
		# F-Bomb Effect
#		print("bomb")
#		print(bomb)
		for c in range(2,5):
			if rank_card[c] == A3:
				var r_c = rank_card[c]
				rank_card[c] = rank_card[c-1]
				rank_card[c-1] = r_c
				RankAnimation.play("Car_"+str(c-1)+str(c))
				yield(RankAnimation, "animation_finished")
		if bomb > 0 and not ranking.get_node("Rank1").get_data().protection:
#			print(bomb)
			for i in range(bomb):
				var r_c = rank_card[1]
				rank_card[1] = rank_card[2]
				rank_card[2] = r_c
				TurnAnimation.play("explode")
				yield(TurnAnimation, "animation_finished")
				# explodsion 
	#			TurnAnimation.play("explode")
	#			yield(TurnAnimation, "animation_finished")
				RankAnimation.play("Car_12")
				yield(RankAnimation, "animation_finished")
		TurnAnimation.play("ShowItem")
		yield(TurnAnimation, "animation_finished")
		# Oil Leak Effect
		if oil != 5:
			for c in range(oil+1,5):
		#			yield(TurnAnimation, "animation_finished")
				var data = ranking.get_node("Rank"+str(c)).get_data()
				change(c, item_speed[rank_card[c]], false)
				data.speed -= 5
				parent.get_node("TurnAnimation").play("OL")
				yield(TurnAnimation, "animation_finished")
		TurnAnimation.play("ShowItem")
		yield(TurnAnimation, "animation_finished")
		for c in range(1,5):
			if rank_card[c] == "":
				pass
			else:
	#			yield(TurnAnimation, "animation_finished")
				var data = ranking.get_node("Rank"+str(c)).get_data()
				change(c, item_speed[rank_card[c]])
				data.speed += item_speed[rank_card[c]]
				yield(TurnAnimation, "animation_finished")
		TurnAnimation.play("ShowItem")
		yield(TurnAnimation, "animation_finished")
		for r in range(0, 3):
			var speed1 = ranking.get_children()[r].get_data().speed
			var speed2 = ranking.get_children()[r+1].get_data().speed
			if speed1 < speed2 and not ranking.get_children()[r].get_data().protection:
				RankAnimation.play("Car_"+str(r+1)+str(r+2))
	#			RankManager.swap(r, r+1)
				yield(RankAnimation, "animation_finished")
				TurnAnimation.play("ShowItem")
				yield(TurnAnimation, "animation_finished")
		# UNTESTED
		start_all()
		var turbo = 1
		
		turbo(1, 1)
		ranking.get_node("Rank1").get_data().turbo += 1
		yield(TurnAnimation, "animation_finished")
		turbo(2, 1)
		ranking.get_node("Rank2").get_data().turbo += 1
		yield(TurnAnimation, "animation_finished")
		turbo(3, 2)
		ranking.get_node("Rank3").get_data().turbo += 2
		yield(TurnAnimation, "animation_finished")
		turbo(4, 2)
		ranking.get_node("Rank4").get_data().turbo += 2
		yield(TurnAnimation, "animation_finished")
	turn %= total_players
	if not end_game:
		get_player().start_turn()

func get_player():
	var player_id
#	for node in parent.get_node("Ranking").get_children():
#		if turn+1 == node.rank:
#			player_id = node.get_data().player_id
#			break
	player_id = parent.get_node("Ranking").get_children()[turn].get_data().player_id
#	print(player_id)
	return parent.get_node("Players").get_children()[player_id]

func change(rank, value=1, plus=true):
	if plus:
		get_parent().get_node("Diff").text = "+"+str(value)
	else:
		get_parent().get_node("Diff").text = "-"+str(value)
	TurnAnimation.play("change_"+str(rank))
#	yield(TurnAnimation, "animation_finished")

func turbo(rank, value=2, plus=true):
	if plus:
		get_parent().get_node("Diff").text = "+"+str(value)
	else:
		get_parent().get_node("Diff").text = "-"+str(value)
	TurnAnimation.play("turbo_"+str(rank))
#	yield(TurnAnimation, "animation_finished")

func end_turn():
#	print(false)
	pass

func start_all():
	# player properties clear
	for player in players.get_children():
		player.play = ""
		player.discards = 0
	# manager properties clear
	for c in range(1,5):
		rank_card[c] = ""
	# items' frame clear
	for player in ranking.get_children():
		player.show_item = false
		player.get_data().protection = false
		player.get_data().speed = 0
		player.get_data().item = item_f["empty"]
	congra()

#func end_all():
#	# UNTESTED
#	var oil = false
#	for c in range(1,5):
#		if rank_card[c] == "":
#			pass
#		else:
#			TurnAnimation.play("ShowItem")
##			yield(TurnAnimation, "animation_finished")
##			print(true)
#			print(rank_card)
#			ranking.get_node("Rank"+str(c+1)).get_node("Item").frame = item_f[rank_card[c]]
#
#	for c in range(0,4):
#		if rank_card[c] == "":
#			pass
#		else:
#			TurnAnimation.play("ShowItem")
##			yield(TurnAnimation, "animation_finished")
#			var data = ranking.get_node("Rank1").get_data()
#			data.item = item_f[rank_card[c]]
#			change(c, item_speed)
#			data.speed += item_speed
#	for r in range(0, 3):
#		var speed1 = ranking.get_children()[r].get_data().speed
#		var speed2 = ranking.get_children()[r+1].get_data().speed
#		if speed1 < speed2:
#			RankAnimation.play("Car_"+str(r)+str(r+1))
##			RankManager.swap(r, r+1)
#			yield(RankAnimation, "animation_finished")
#
#	# UNTESTED

#func show_item():
#
#	parent.get_node("Ranking/Rank"+str(item)).get_node("Item").frame = 0
#
#	pass

func congra():
	parent.get_node("DeckRemain").text = "Deck Remains: " + str(deck.deck_size())
	if deck.deck_size() == 0 and not end_game:
		end_game = true
		var winner = ranking.get_node("Rank1").get_data().player_id
		if winner == 2:
			get_parent().get_node("WinnerIs").text = "The Winner is You"
			get_parent().get_node("WinnerIs").show()
		else:
			get_parent().get_node("WinnerIs").text = "The Winner is CP"+str(winner+1)
			get_parent().get_node("WinnerIs").show()
		get_tree().paused = true
		print("The winner is p" + str(ranking.get_node("Rank1").get_data().player_id+1) + ".")
#		get_tree().get_root().set_pause(true)

#func is_your_turn():
#	for rank in parent.get_node("Ranking").get_children():
#		if rank.car.player_id == player_id:
#			player_turn = rank.rank
#	if turn == player_turn:
#		return true
#	else:
#		return false

