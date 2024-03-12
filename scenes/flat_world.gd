extends Node3D
@onready var slime: Slime = $Slime
@onready var player: Player = $Player

@onready var town: Node3D = $waypoints/town
@onready var start: Node3D = $waypoints/start
@onready var midway: Node3D = $waypoints/midway
@onready var garden: Node3D = $waypoints/garden

@onready var dialog_anchor: Control = %DialogAnchor
@onready var music_animation: AnimationPlayer = $MUSIC/music_animation
@onready var happy: AudioStreamPlayer = $MUSIC/Happy
@onready var spooky: AudioStreamPlayer = $MUSIC/Spooky
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var in_walls: MazeWall = %"in-walls"
@onready var out_walls: MazeWall = %"out-walls"

@onready var good_slime: AudioStream = preload("res://other-assets/slime_good.wav")
@onready var spooky_roar: AudioStream = preload("res://other-assets/spooky_roar.wav")
@onready var spooky_speak: AudioStream = preload("res://other-assets/spooky_blip.wav")
@onready var color_rect: ColorRect = $CanvasLayer/ColorRect

@onready var navigation_region_3d: NavigationRegion3D = $NavigationRegion3D
@onready var chase_timer: Timer = $ChaseTimer

# town
const lines_0: Array[String] = [
	"Have you finished your slice of pie?",
	"I know you always love my rhubarb pie haha!",
	"well, it's such a nice day out",
	"why don't we go for a walk?"
]
# start
const lines_1: Array[String] = [
	"ya know, we've known each other for many years now.",
	"and ever since you moved into town,",
	"you've become my closest friend.",
	"I want to show you something special to me"
]
#midway
const lines_2: Array[String] = [
	"I want to finally show you where I grow my rhubarb",
	"My secret rhubarb garden...",
	"Please follow me"
]
#garden
const lines_3: Array[String] = [
	"Okay here we are, this is my happy place",
	"Remember the 1st month we met?",
	"When I invited you over for dinner?",
	"I cooked you a rhubarb pie for the first time.",
	"I told you that rhubarb was my favorite food..",
	"well...",
	"That's not *entirely* true...",
	"While I love rhubarb,",
	"I like food stuffed with rhubarb more...",
	"I have waited 5 years for this moment...",
	"ALL the baking I have done for you",
	"ALL for right. now.",
	"Finally...",
	"MY dinner is served!"
]

var stage: int = 0

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	# listen to dialog finishing on handle_dialog func
	DialogManager.dialog_finished.connect(_handle_dialog_finished)
	# manage nav mesh and wall visible
	await out_walls.toggle_exists()
	navigation_region_3d.bake_navigation_mesh()
	# start gameplay
	slime.show_able_to_talk()
	# set up music
	happy.playing = true
	spooky.playing = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("advance_dialog") and player.position.distance_to(slime.position) < 3 and slime.talkable:
		slime.hide_able_to_talk()
		on_player_initiate_dialog()

func _process(_delta: float) -> void:
	if stage == 4 and chase_timer.is_stopped():
		slime.set_next_nav_target(player.position)
		if slime.position.distance_to(player.position) < 1.5:
			get_tree().change_scene_to_file("res://scenes/ui/menus/game_over_menu.tscn")

func _on_slime_target_reached() -> void:
	slime.show_able_to_talk()

func on_player_initiate_dialog() -> void:
	player.toggle_locked_movement()
	match stage:
		0:
			# town
			DialogManager.start_dialog(dialog_anchor, lines_0, good_slime)
		1:
			# start
			DialogManager.start_dialog(dialog_anchor, lines_1, good_slime)
		2:
			# midway
			DialogManager.start_dialog(dialog_anchor, lines_2, good_slime)
		3:
			# garden
			slime.turn_evil()
			handle_spooky_map_changes()
			rebake_nav_mesh()
			DialogManager.start_dialog(dialog_anchor, lines_3, good_slime)

# what to do when finished talking (usually move to next place or follow player)
func _handle_dialog_finished() -> void:
	player.toggle_locked_movement()
	match stage:
		0:
			slime.set_next_nav_target(start.position)
		1:
			slime.set_next_nav_target(midway.position)
		2:
			slime.set_next_nav_target(garden.position)
		3:
			slime.slime_speed = 3.0
			chase_timer.start(3)
			animation_player.stop()
			animation_player.play("enviro_to_spooky")

	stage += 1
	print("advancing stage")

func handle_spooky_map_changes() -> void:
	spooky.playing = true
	music_animation.play("happy_to_spooky")

func rebake_nav_mesh() -> void:
	await in_walls.toggle_exists()
	await out_walls.toggle_exists()
	navigation_region_3d.bake_navigation_mesh()


func _on_escape_checker_body_entered(body: Node3D) -> void:
	if body is Player and stage == 4:
		get_tree().change_scene_to_file("res://scenes/ui/menus/victory.tscn")
