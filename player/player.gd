extends CharacterBody3D

@export_category("Player Movement")
@export var speed: float = 500
@export var jump_velocity: float = 4.5
@onready var camera: Camera3D = $Camera3D

var velocity_y: float = 0
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var look_sensitivity: float = ProjectSettings.get_setting("player/look_sensitivity")

func _physics_process(delta: float) -> void:
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
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * look_sensitivity)
		camera.rotate_x(-event.relative.y * look_sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)
