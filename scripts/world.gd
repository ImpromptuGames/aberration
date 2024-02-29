extends Node3D

@onready var player: CharacterBody3D = $Player
@onready var slime: Node3D = $slime
@onready var directional_light_3d: DirectionalLight3D = $DirectionalLight3D
@onready var world_environment: WorldEnvironment = $WorldEnvironment
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var shrinking: bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if shrinking:
		player.potion_scale = player.potion_scale * 0.999 
		slime.scale = slime.scale * 1.0001
		if player.potion_scale <= 0.1:
			shrinking = false


func _on_area_3d_body_entered(body: Node3D) -> void:
	shrinking = true


func _on_zoomtrigger_body_entered(body: Node3D) -> void:
	player.spooky_zoom()
	if animation_player != null:
		animation_player.stop()
		animation_player.play("increase_fog")



func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	animation_player.queue_free()
