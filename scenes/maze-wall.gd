class_name  MazeWall
extends Node

@export var exists: bool = true

func toggle_exists():
	var walls: Array[Node] = get_children()
	for wall in walls:
		if exists:
			wall.hide()
		else:
			wall.show()
			
	exists = !exists
