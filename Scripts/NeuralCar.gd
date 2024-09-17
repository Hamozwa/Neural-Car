extends KinematicBody2D

var acceleration = 5
var max_speed = 500
var friction = 0.1
var rotation_speed = 2
var timetillkill = 2

var inputs = []
var weights_and_biases = [[[[-0.149189, -0.90034, 1.688669, 1.25595, 0.606232, -0.869079, -0.00802, 0.636579], [1.96072, 1.050401, 0.084083, -0.417633, -1.739302, -0.542901, -0.59012, -0.9767], [-2.422781, 1.588818, -0.315183, 0.526115, -1.819884, -0.99039, 1.123964, -0.224363], [-0.004056, 1.162116, 1.328615, 0.766649, -0.721014, -0.11561, -0.149434, -0.643582], [-1.769302, -0.148066, -0.483032, 0.419353, 0.515134, -0.921704, 0.977683, 1.179088], [0.75168, 0.230578, 0.582524, 1.930105, 0.450803, 1.480572, -0.216818, -0.284887]], [-1.001346, 0.314162, -2.998606, 0.976068, 1.273748, 0.24214]], [[[-1.518076, -0.334388, 0.035407, -0.101398, 1.599722, -0.764631], [-0.698145, -3.048421, -0.183956, 0.985259, -0.812041, 1.015491], [-0.120332, 3.045244, -0.284771, 1.31064, 1.02462, 0.406459], [-0.577708, -1.592925, 2.006015, -0.475708, -0.721852, -1.666991]], [0.348846, 0.091299, -1.136108, -0.791179]]]
var start_time = OS.get_unix_time()
var time_since_progress = 0
export var F:NodePath
export var L:NodePath
export var R:NodePath
export var B:NodePath
export var FL:NodePath
export var FR:NodePath
export var BL:NodePath
export var BR:NodePath
var speed_input = 0
var direction = 0
var velocity = Vector2.ZERO
var vellen = 1
var cpreached = 0
var C1 = false
var C2 = false
var C3 = false
var C4 = false
var C5 = false
var C6 = false
var C7 = false
var C8 = false
var C9 = false
var C10 = false
var C11 = false
var C12 = false
var C13 = false
var C14 = true

func _ready():
	var car = self
	KC.emit_signal("add_to_car_list", car)

func get_input():
	direction = 0
	speed_input = 0
	
	var neural_order = get_neural_input()
	
	if neural_order[0] > 0.5:
		speed_input += 1
	if neural_order[1] > 0.5:
		speed_input -= 1
	if neural_order[2] > 0.5:
		direction += rotation_speed
	if neural_order[3] > 0.5:
		direction -= rotation_speed
		
	#NO MORE USER INPUT - AI IS FREE BABYYYYYYYYYY
#	if Input.is_action_pressed("W"):
#		speed_input += 1
#	if Input.is_action_pressed("A"):
#		direction -= rotation_speed
#	if Input.is_action_pressed("S"):
#		speed_input -= 1
#	if Input.is_action_pressed("D"):
#		direction += rotation_speed

func get_neural_input():
	inputs = [
		get_node(F).distance,
		get_node(R).distance,
		get_node(L).distance,
		get_node(B).distance,
		get_node(FL).distance,
		get_node(FR).distance,
		get_node(BR).distance,
		get_node(BL).distance]
	var neuralinput = neuralprocess(inputs, weights_and_biases)
	return neuralinput


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	get_input()
	rotation += direction * rotation_speed * delta
	velocity += transform.x * speed_input * acceleration
	if speed_input == 0:
		velocity.x = lerp(velocity.x, 0, friction)
		velocity.y = lerp(velocity.y, 0, friction)
	vellen = sqrt(velocity.x*velocity.x + velocity.y*velocity.y)
	if vellen > max_speed:
		velocity.x = velocity.x * max_speed/vellen
		velocity.y = velocity.y * max_speed/vellen
	velocity = move_and_slide(velocity)
	
	time_since_progress += delta
	if time_since_progress > timetillkill:
		death()

func sigmoid_function(siginput):
	return (1/(1+pow(2.72,-1*siginput)))
	
func neuron(previouslayer,neuronweights,neuronbias):
	var neuronoutput = 0
	for i in range(0,len(previouslayer)):
		neuronoutput += previouslayer[i] * neuronweights[i]
	neuronoutput += neuronbias
	neuronoutput = sigmoid_function(neuronoutput)
	return neuronoutput
#	if test:
#		print([previouslayer,neuronweights,neuronbias])
#		test = false
#	return 1

func neuronlayer(previouslayer,layerweights,layerbias,neuronnumber):
	var layeroutput = []
	for i in range(0,neuronnumber):
		layeroutput.append(neuron(previouslayer,layerweights[i],layerbias[i]))
	return layeroutput

#neuralinfo = [ [layer1], [layer2] ]
#layer1 = [ [weights], [biases] ]
#weights = [ [neuron1weights], [neuron2weights], ... ]

func neuralprocess(neuralinput,neuralinfo):
	var hidden = neuronlayer(neuralinput,neuralinfo[0][0],neuralinfo[0][1],6)
	return neuronlayer(hidden, neuralinfo[1][0],neuralinfo[1][1],4)

func death():
	var time_elapsed = OS.get_unix_time() - start_time + 1
#	var fitness = cpreached/float(time_elapsed)
	get_node("/root/KC").last_breath(cpreached, weights_and_biases)
	queue_free()
	

func _on_DetectorArea_area_entered(area):
	if area.get_name() == "Walls":
		death()
	
	if area.get_name() == "CP1":
		if C14:
			cpreached += 1
			C14 = false
			C1 = true
			time_since_progress = 0
	
	if area.get_name() == "CP2":
		if C1:
			cpreached += 1
			C1 = false
			C2 = true
			time_since_progress = 0

	if area.get_name() == "CP3":
		if C2:
			cpreached += 1
			C2 = false
			C3 = true
			time_since_progress = 0
	
	if area.get_name() == "CP4":
		if C3:
			cpreached += 1
			C3 = false
			C4 = true
			time_since_progress = 0
	
	if area.get_name() == "CP5":
		if C4:
			cpreached += 1
			C4 = false
			C5 = true
			time_since_progress = 0
	
	if area.get_name() == "CP6":
		if C5:
			cpreached += 1
			C5 = false
			C6 = true
			time_since_progress = 0

	if area.get_name() == "CP7":
		if C6:
			cpreached += 1
			C6 = false
			C7 = true
			time_since_progress = 0
	
	if area.get_name() == "CP8":
		if C7:
			cpreached += 1
			C7 = false
			C8 = true
			time_since_progress = 0
	
	if area.get_name() == "CP9":
		if C8:
			cpreached += 1
			C8 = false
			C9 = true
			time_since_progress = 0
	
	if area.get_name() == "CP10":
		if C9:
			cpreached += 1
			C9 = false
			C10 = true
			time_since_progress = 0

	if area.get_name() == "CP11":
		if C10:
			cpreached += 1
			C10 = false
			C11 = true
			time_since_progress = 0
	
	if area.get_name() == "CP12":
		if C11:
			cpreached += 1
			C11 = false
			C12 = true
			time_since_progress = 0
	
	if area.get_name() == "CP13":
		if C12:
			cpreached += 1
			C12 = false
			C13 = true
			time_since_progress = 0
	
	if area.get_name() == "CP14":
		if C13:
			cpreached += 1
			C13 = false
			C14 = true
			time_since_progress = 0
