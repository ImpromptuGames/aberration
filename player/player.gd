class_name Player
extends CharacterBody3D

@onready var camera: Camera3D = $Camera3D
@onready var animation_player: AnimationPlayer = $Camera3D/AnimationPlayer

@export_category("Player Movement")
@export var speed: float = 500
@export var jump_velocity: float = 4.5

var locked: bool = false

var velocity_y: float = 0
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var look_sensitivity: float = ProjectSettings.get_setting("player/look_sensitivity")

func _physics_process(delta: float) -> void:
	if not locked:
		var horizontal_velocity: Vector2 = Input.get_vector("left","right","forward","backward").normalized() * speed * delta
		velocity = horizontal_velocity.x * global_transform.basis.x + horizontal_velocity.y * global_transform.basis.z
		
		if is_on_floor():
			velocity_y = 0
			if Input.is_action_just_pressed("jump"): velocity_y = jump_velocity
		else:
			velocity_y -= gravity * delta
		velocity.y = velocity_y
	move_and_slide()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion: # and not locked: <- optional camera lock
		rotate_y(-event.relative.x * look_sensitivity)
		camera.rotate_x(-event.relative.y * look_sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)

func toggle_locked_movement() -> void:
	locked = not locked

func spooky_zoom() -> void:
	toggle_locked_movement()
	animation_player.stop()
	animation_player.play("spooky_zoom")
