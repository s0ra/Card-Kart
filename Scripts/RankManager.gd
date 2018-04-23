extends Node

var rank_id = {1:1, 2:2, 3:3, 4:4}

func _ready():
	var rank = 1
	for node in get_parent().get_node("Ranking").get_children():
		node.rank = rank
		node.get_data().player_id = rank-1
		rank += 1
	rank = 1
	for node in get_parent().get_node("Players").get_children():
		node.rank = rank
		rank += 1
		
	pass

func _process(delta):
#	if Input.is_action_just_pressed("touch"):
#		get_parent().get_node("RankAnimation").play("Car_12")

	pass

func swap(r1, r2):
	var data1 = get_parent().get_node("Ranking/Rank"+str(r1)).get_data()
	if !data1.protection:
		get_parent().get_node("Ranking/Rank"+str(r1)).set_data(get_parent().get_node("Ranking/Rank"+str(r2)).get_data())
		get_parent().get_node("Ranking/Rank"+str(r2)).set_data(data1)
		for node in get_parent().get_node("Players").get_children():
			if node.rank == r1:
				node.rank = r2
				rank_id[r2] = node.player_id
			elif node.rank == r2:
				node.rank = r1
				rank_id[r1] = node.player_id
	pass
