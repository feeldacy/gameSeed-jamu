extends Area3D

@export var ingredient_scene: PackedScene

func _input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:

			var bowl = get_tree().get_first_node_in_group("bowl")

			if bowl:
				bowl.add_ingredient(ingredient_scene)
