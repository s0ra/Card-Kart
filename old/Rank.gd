extends NinePatchRect

var id = 0

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
	get_node("NinePatchRect/HBoxContainer/Label").text = "Speed:" + str(id)
	pass

func set_id(id):
	self.id = id