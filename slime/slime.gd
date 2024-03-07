class_name Slime
extends CharacterBody3D
@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var evil: bool = false

signal target_reached()

@export_category("Slime Properties")
@export var slime_speed: float = 3.0
@export var scale_speed: float = 0.05

func set_next_nav_target(target_pos: Vector3) -> void:
	if position.distance_to(target_pos) >= 1:
		navigation_agent_3d.set_target_position(target_pos)

func get_player_attention(player_pos: Vector3) -> void:
	navigation_agent_3d.set_target_position(player_pos)
	navigation_agent_3d.set_target_position(navigation_agent_3d.get_next_path_position())

func _process(delta: float) -> void:
	pass

func _physics_process(_delta: float) -> void:
	var destination = navigation_agent_3d.get_next_path_position()
	if destination.distance_to(position) >= 0.1:
		var local_destintaion = destination - global_position
		var direction = local_destintaion.normalized()
		velocity = direction * slime_speed
		move_and_slide()


func _on_navigation_agent_3d_navigation_finished() -> void:
	target_reached.emit()
	
func turn_evil() -> void:
	animation_player.stop()
	animation_player.play("turn_evil")
