extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var playing = false

func _ready():
	get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_2D, SceneTree.STRETCH_ASPECT_KEEP, Vector2(400, 640))
	pass

func _process(delta):
	if Input.is_action_just_pressed("start"):
		playing = true
		get_node("Hands/Start").modulate = Color(1, 1, 1, 0.3)
	elif Input.is_action_just_released("start"):
		get_node("Hands/Start").modulate = Color(1, 1, 1, 1)
		if get_global_mouse_position().y > 600:
			get_node("Hands/Start").hide()
			get_node("DiscardSound").play()
			playing = false
			yield(get_node("DiscardSound"), "finished")
			get_tree().change_scene("res://Scenes/Game.tscn")
		playing = false
	if Input.is_action_just_pressed("setting"):
		playing = true
		get_node("Hands/Setting").modulate = Color(1, 1, 1, 0.3)
	elif Input.is_action_just_released("setting"):
		get_node("Hands/Setting").modulate = Color(1, 1, 1, 1)
		if get_global_mouse_position().y > 600:
			get_node("Hands/Setting").hide()
			get_node("DiscardSound").play()
			playing = false
#			yield(get_node("DiscardSound"), "finished")
			get_node("Title").hide()
			get_node("Tutorial").hide()
			get_node("Credits").hide()
			get_node("Setting").show()
		playing = false
	if Input.is_action_just_pressed("tutorial"):
		playing = true
		get_node("Hands/Tutorial").modulate = Color(1, 1, 1, 0.3)
	elif Input.is_action_just_released("tutorial"):
		get_node("Hands/Tutorial").modulate = Color(1, 1, 1, 1)
		if get_global_mouse_position().y > 600:
			get_node("Hands/Tutorial").hide()
			get_node("DiscardSound").play()
			playing = false
#			yield(get_node("DiscardSound"), "finished")
			get_node("Title").hide()
			get_node("Tutorial").show()
			get_node("Credits").hide()
			get_node("Setting").hide()
		playing = false
	if Input.is_action_just_pressed("credits"):
		playing = true
		get_node("Hands/Credits").modulate = Color(1, 1, 1, 0.3)
	elif Input.is_action_just_released("credits"):
		get_node("Hands/Credits").modulate = Color(1, 1, 1, 1)
		if get_global_mouse_position().y > 600:
			get_node("Hands/Credits").hide()
			get_node("DiscardSound").play()
			playing = false
#			yield(get_node("DiscardSound"), "finished")
			get_node("Title").hide()
			get_node("Tutorial").hide()
			get_node("Credits").show()
			get_node("Setting").hide()
		playing = false
	if playing:
		var position = get_global_mouse_position()
		get_node("PlayCard").position = position
		get_node("PlayCard").visible = true
	else:
		get_node("PlayCard").visible = false