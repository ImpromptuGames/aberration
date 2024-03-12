class_name  MazeWall
extends Node3D

@export var exists: bool = true
@onready var wall_container: Node3D = %WallContainer
@onready var navigation_region_3d: NavigationRegion3D = %NavigationRegion3D


func toggle_exists():
	print("toggled existance of %s" % name)
	var walls: Array[Node] = get_children()
	for wall in walls:
		var collider = wall.get_node("./wall/StaticBody3D/CollisionShape3D") as CollisionShape3D
		if exists:
			wall.hide()
			collider.disabled = true
		else:
			wall.show()
			collider.disabled = false
			
	
	if exists:
		reparent(wall_container)
	else:
		reparent(navigation_region_3d)
	exists = !exists
