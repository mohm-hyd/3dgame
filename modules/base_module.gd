class_name BaseModule 

extends Node3D

@onready var level = $"../"


func recycle_module():
	if level:
		level.spawnModule(position.x + (level.amnt * level.offset))
	queue_free()
