extends Node

@onready var text_box_scene: PackedScene = preload("res://scenes/ui/text_box.tscn")

signal dialog_finished()

var dialog_anchor: Control

var dialog_lines: Array[String] = []
var current_line_index: int = 0

var text_box: TextBox
var text_box_position: Vector2


var sfx: AudioStream

var is_dialog_active: bool = false
var can_advance_line: bool = false

func start_dialog(anchor: Control, lines: Array[String], speech_sfx: AudioStream) -> void:
	if is_dialog_active:
		return
	dialog_lines = lines
	dialog_anchor = anchor
	text_box_position = dialog_anchor.position
	sfx = speech_sfx
	_show_text_box()
	
	is_dialog_active = true

func _show_text_box() -> void:
	text_box = text_box_scene.instantiate()
	text_box.finished_displaying.connect(_on_text_box_finished_displaying)
	dialog_anchor.add_child(text_box)
	text_box.global_position.x = text_box_position.x - text_box.size.x / 2
	text_box.global_position.y = text_box_position.y - text_box.size.y / 2
	text_box.display_text(dialog_lines[current_line_index], sfx)
	can_advance_line = false

func _on_text_box_finished_displaying() -> void:
	can_advance_line = true

func _unhandled_input(event: InputEvent) -> void:
	if (
		event.is_action_pressed("advance_dialog") &&
		is_dialog_active &&
		can_advance_line
	):
		text_box.queue_free()
		
		current_line_index += 1
		if current_line_index >= dialog_lines.size():
			is_dialog_active = false
			current_line_index = 0
			dialog_finished.emit()
			return
		
		_show_text_box()
