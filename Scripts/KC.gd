extends Node

var gensize = 500
var batchsize = 50
var parent_number = 30
var mutation_mean: float = 1.0
var mutation_deviation: float = 5.0
var weight_start_mean: float = 0.0
var weight_start_deviation: float = 1.0
var bias_start_mean: float = 0.0
var bias_start_deviation: float = 1.0

var gennumber = 1
var generation = []
var most_fit = []
var rng = RandomNumberGenerator.new()
signal GenLabel(message)
signal spawn_cars(car_info)
signal add_to_car_list(car)
onready var Track = get_tree().get_root().find_node("Track",true,false)

class MyCustomSorter:
	static func sort_ascending(a, b):
		if a[0] < b[0]:
			return true
		return false

func last_breath(fitness, neuralinfo):
	generation.append([fitness, neuralinfo])
	if len(generation) == gensize:
		generation_complete()
		generation = []
	
#neuralinfo = [ [layer1], [layer2] ]
#layer1 = [ [weights], [biases] ]
#weights = [ [neuron1weights], [neuron2weights], ... ]
#most_fit = [ [fitness1, neuralinfo1], ... ]
	
func generation_complete():
	generation.sort_custom(MyCustomSorter, "sort_ascending")
	most_fit = generation.slice((-1*parent_number),-1)
#	for q in range(0, len(most_fit)):
#		print("Score "+str(q)+":"+str(most_fit[q][0]))
	print("highest fitness: " + str(most_fit[-1][0])) # SELECTING WRONG <-------------------------------------------------
	#Digital Labour Ward
	generation = []
	for j in range(gensize):
		var random_parent = rng.randi_range(0,len(most_fit)-1)
		var currentinfo = most_fit[random_parent][1]
		for layer in currentinfo:
			for weightlist in layer[0]:
				for weight in weightlist:
					var multiplier = rng.randfn(mutation_mean, mutation_deviation)
					weight = weight*multiplier
			for bias in layer[1]:
				var multiplier = rng.randfn(mutation_mean, mutation_deviation)
				bias = bias * multiplier
		generation.append(currentinfo)
	gennumber += 1
	emit_signal("GenLabel","Generation: "+str(gennumber))
	spawn_generation(generation)
		

#neuralinfo = [ [layer1], [layer2] ]
#layer1 = [ [weights], [biases] ]
#weights = [ [neuron1weights], [neuron2weights], ... ]
#most_fit = [ [fitness1, neuralinfo1], ... ]

func spawn_generation(gen):
	emit_signal("spawn_cars",gen)

func _ready():
	yield(Track, "ready")
	
	#Generation 1
	for specnumber in range(gensize):
		var currentspec = []
		for layernumber in range(2):
			var currentweights = []
			var currentbiases = []
			
			for layerneuronnumber in range(6-2*layernumber):
				var currentneuronweights = []
				for weightnumber in range(8-2*layernumber):
					currentneuronweights.append(rng.randfn(weight_start_mean, weight_start_deviation))
				currentweights.append(currentneuronweights)
				
				currentbiases.append(rng.randfn(bias_start_mean, bias_start_deviation))
			currentspec.append([currentweights, currentbiases])
		generation.append(currentspec)
	
	spawn_generation(generation)
	generation = []
		
