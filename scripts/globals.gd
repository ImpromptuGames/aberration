extends Node

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("escape"):
		get_tree().quit()
