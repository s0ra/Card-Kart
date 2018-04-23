extends Node

var music_on = true
var se_on = true

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func mute_m():
	AudioServer.set_bus_mute(1, music_on)
	if not music_on:
		music_on = true
	else:
		music_on = false

func mute_se():
	AudioServer.set_bus_mute(2, se_on)
	if not se_on:
		se_on = true
	else:
		se_on = false