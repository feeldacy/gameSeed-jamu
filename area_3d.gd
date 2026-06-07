extends Area3D

func _input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:

			var kitchen = get_tree().current_scene

			kitchen.add_to_bowl(get_parent())
