class_name MainMenu
extends Control

@onready var play_button: Button = $MarginContainer/VBoxContainer/PlayButton
@onready var exit_button: Button = $MarginContainer/VBoxContainer/ExitButton


func _on_play_button_pressed() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	get_tree().change_scene_to_file("res://scenes/flat_world.tscn")


func _on_exit_button_pressed() -> void:
	get_tree().quit()
