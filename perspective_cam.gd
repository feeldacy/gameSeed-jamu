extends Node3D

@onready var bowl = $mangkok

func add_to_bowl(ingredient):
	var copy = ingredient.duplicate()

	bowl.add_child(copy)

	copy.position = Vector3(0, 0.2, 0)
	
