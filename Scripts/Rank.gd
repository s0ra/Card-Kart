extends Sprite

var rank
var show_item = false

class Car:
	var player_id = 0
	var turbo = 0
	var profile = 0
	var speed = 0
	var item = 0
	var protection = false

var car = Car.new()

func _ready():
	car.profile = get_node("Profile").frame
	car.item = get_node("Item").frame
	pass

func _process(delta):
	if car.turbo >= 8:
		car.turbo = 8
	get_node("Profile").frame = car.turbo
	get_node("Rank").text = str(rank)
	get_node("Speed").text = "Speed: " + str(car.speed)
	get_node("Profile2").frame = car.profile
	if show_item:
		get_node("Item").frame = car.item
	elif car.item == 0:
		get_node("Item").frame = car.item
	else:
		get_node("Item").frame = 1
		
	pass

func set_data(car):
	self.car = car

func get_data():
	return self.car
