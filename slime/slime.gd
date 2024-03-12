class_name Slime
extends CharacterBody3D
@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var roar_timer: Timer = $RoarTimer
@onready var roar_player: AudioStreamPlayer3D = $RoarPlayer
@onready var interaction_arrow: Node3D = $interaction_arrow

var evil: bool = false
var talkable: bool = false

signal target_reached()

@export_category("Slime Properties")
@export var slime_speed: float = 5.0

func set_next_nav_target(target_pos: Vector3) -> void:
	if position.distance_to(target_pos) >= 1:
		navigation_agent_3d.set_target_position(target_pos)

func get_player_attention(player_pos: Vector3) -> void:
	navigation_agent_3d.set_target_position(player_pos)
	navigation_agent_3d.set_target_position(navigation_agent_3d.get_next_path_position())

func _process(_delta: float) -> void:
	# roar when close to player
	if (
		evil 
		and navigation_agent_3d.get_final_position().distance_to(position) < 5 
		and roar_timer.is_stopped()
		):
		roar_player.pitch_scale = randf_range(0.9,1.1)
		roar_player.play()
		roar_timer.start()

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
	await  animation_player.animation_finished
	evil = true

func show_able_to_talk() -> void:
	interaction_arrow.show()
	talkable = true

func hide_able_to_talk() -> void:
	interaction_arrow.hide()
	talkable = false
