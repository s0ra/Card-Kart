extends Sprite

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _on_CheckBox_pressed():
	Music.mute_m()


func _on_CheckBox2_pressed():
	Music.mute_se()
