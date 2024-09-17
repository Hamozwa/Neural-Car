extends Node2D

var cars = []


func spawn_neural_cars(generation):
	for i in range(0,len(generation)):
		var car = load("res://NeuralCar.tscn").instance()
		car.position=Vector2(320,100)
		car.weights_and_biases = generation[i]
		add_child(car)
		yield(get_tree(), "physics_frame")
	
func add_car(inst):
	for item in cars:
		inst.add_collision_exception_with(item)
	cars.append(inst)
	
func _ready():
	KC.connect("spawn_cars",self,"spawn_neural_cars")
	KC.connect("add_to_car_list",self,"add_car")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _physics_process(delta):
#	print(delta)
