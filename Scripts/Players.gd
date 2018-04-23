extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	var id = 0
	for player in get_children():
		player.player_id = id
		id += 1
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
