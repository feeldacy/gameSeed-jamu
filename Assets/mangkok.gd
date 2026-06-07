extends Node3D

@export var ingredient_offset := Vector3.ZERO

func add_ingredient(ingredient_scene):
	var ingredient = ingredient_scene.instantiate()

	add_child(ingredient)

	ingredient.position = ingredient_offset

	ingredient_offset.y += 0.05
