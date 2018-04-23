extends Node

var item_speed = {"":0, "accel1":3, "accel2":4, "accel3":4, 
                  "oil_leak":0, "f-bomb":5, "protection":0}

var item_f = {"empty":0, "unknown":1, "accel1":2, "accel2":3, "accel3":4, 
              "oil_leak":5, "f-bomb":6, "protection":7}

var item_turbo = {"":0, "accel1":1, "accel2":2, "accel3":3, 
                  "oil_leak":0, "f-bomb":4, "protection":1}


func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
