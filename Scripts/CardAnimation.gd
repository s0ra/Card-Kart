extends AnimationPlayer

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	pass

func _process(delta):
	pass

func _on_CardAnimation_animation_finished(anim_name):
	seek(0, true)
	pass # replace with function body