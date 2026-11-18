extends Node3D

@export var modules: Array[PackedScene] = []
var amnt = 15
var rng = RandomNumberGenerator.new()
var offset = 7
var initObs = 0


var scroll_speed = 10.0     
var max_speed = 30.0       
var acceleration = 0.5     

func _ready():
	for n in amnt:
		spawnModule(n * offset)

func _process(delta):
	if scroll_speed < max_speed:
		scroll_speed += acceleration * delta

	for child in get_children():
		if child is Node3D:

			child.position.x -= scroll_speed * delta
			
			if child.position.x < -15:
				spawnModule(child.position.x + (amnt * offset))
				child.queue_free()

func spawnModule(n):
	var instance
	if initObs > 5:
		rng.randomize()
		var num = rng.randi_range(0, modules.size() - 1)
		instance = modules[num].instantiate()
	else:
		instance = modules[0].instantiate()
		initObs += 1
		
	instance.position.x = n
	add_child(instance)
