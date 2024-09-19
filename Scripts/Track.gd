#Track.gd
#Handles Car instantiation

extends Node2D

var cars = []
var held_generation = []
var held_batch_size = 0
var current_batch = 0
var car_address = 0

#Called when current batch is complete
func detect_next_batch():
	for i in range(0,held_batch_size):
		car_address = (50*current_batch) + i
		spawn_car(held_generation[car_address])
	print("batch done")

#Spawns a single car - used for easy reading of code
func spawn_car(neural_info):
	var car = load("res://NeuralCar.tscn").instance()
	car.position=Vector2(320,100)
	car.weights_and_biases = neural_info
	add_child(car)
	yield(get_tree(), "physics_frame")

#Called when next generation is born
func spawn_neural_cars(generation, batch_size):
	#Extracts information from signal to script
	held_batch_size = batch_size
	held_generation = generation
	
	#Starts first batch
	current_batch = 0
	detect_next_batch()
	
func add_car(inst):
	for item in cars:
		inst.add_collision_exception_with(item)
	cars.append(inst)
	
func _ready():
	KC.connect("spawn_cars",self,"spawn_neural_cars")
	KC.connect("add_to_car_list",self,"add_car")
	KC.connect("next_batch",self,"detect_next_batch")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _physics_process(delta):
#	print(delta)
