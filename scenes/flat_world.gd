extends Node3D
@onready var slime: Slime = $Slime
@onready var player: Player = $Player

@onready var town: Node3D = $waypoints/town
@onready var start: Node3D = $waypoints/start
@onready var midway: Node3D = $waypoints/midway
@onready var garden: Node3D = $waypoints/garden

@onready var dialog_anchor: Control = %DialogAnchor
@onready var stage_label: Label = $CanvasLayer/StageLabel
@onready var music_animation: AnimationPlayer = $MUSIC/music_animation
@onready var happy: AudioStreamPlayer = $MUSIC/Happy
@onready var spooky: AudioStreamPlayer = $MUSIC/Spooky
@onready var out_walls: MazeWall = $"out-walls"
@onready var in_walls: MazeWall = $"in-walls"

@onready var good_slime: AudioStream = preload("res://other-assets/slime_good.wav")
@onready var spooky_roar: AudioStream = preload("res://other-assets/spooky_roar.wav")
@onready var spooky_speak: AudioStream = preload("res://other-assets/spooky_blip.wav")

const MAX_STAGE = 3


const lines_catch_up: Array[String] =[
	"HEY!",
	"This secret is really important to me..",
	"Please follow me closer"
]

const lines_1: Array[String] = [
	"Have you finished your slice of pie?",
	"I know you always love my rhubarb pie haha!",
	"well, it's such a nice day out",
	"why don't we go for a walk?"
]
const lines_2: Array[String] = [
	"ya know, we've known each other for many years now.",
	"and ever since you moved into town,",
	"you've become my closest friend.",
	"I want to finally show you where I grow my rhubarb",
	"My secret rhubarb garden...",
	"Please follow me"
]

const lines_3: Array[String] = [
	"Okay here we are, this is my happy place",
	"Remember the 1st month we met? When I invited you over for dinner?",
	"I cooked you a rhubarb pie for the first time.",
	"I told you that rhubarb was my favorite food..",
	"well...",
	"That's not *entirely* true...",
	"While I love rhubarb,",
	"I like food stuffed with rhubarb more...",
	"I have waited 5 years for this moment...",
	"All the backing I have dont for you",
	"All for right. now.",
	"Finally...",
	"M̴̙̐Y̸̾͜ ̴̤̏͒d̸̦͝i̴͇̐n̷̥̘̈́͑ṉ̸̔e̷̮̾́r̸͚̈́̓ ̴̯̪͐̓i̸̯̼̿̿s̶̖̾̕ ̵̙̋̍s̷͍͍͂é̶̳̬r̷͔̈v̴̝̓͘e̶̩̺̋͝d̶̮͊̕!",
]

var stage: int = 0

func _ready() -> void:
	# listen to dialog finishing on handle_dialog func
	DialogManager.dialog_finished.connect(_handle_dialog_finished)
	# start gameplay
	stage_change(0)
	# set up music
	happy.playing = true
	spooky.playing = false

func _process(_delta: float) -> void:
	stage_label.text = "Stage: %s" % stage
	match stage:
		1, 2:
			if slime.position.distance_to(player.position) >= 10:
				slime.get_player_attention(player.position)
				stage -= 1
				DialogManager.start_dialog(dialog_anchor, lines_catch_up, good_slime)
		3:
			# TRACK PLAYER
			slime.set_next_nav_target(player.position)

func stage_change(new_stage: int) -> void:
	stage = min(new_stage, MAX_STAGE)
	match stage:
		0:
			#start in town dialog
			DialogManager.start_dialog(dialog_anchor, lines_1, good_slime)
		1:
			#start
			slime.slime_speed = 5.0
			slime.set_next_nav_target(start.position)
			DialogManager.start_dialog(dialog_anchor, lines_2, good_slime)
		2:
			slime.slime_speed = 6.0
			slime.set_next_nav_target(midway.position)
		3:
			slime.set_next_nav_target(garden.position)
		4:
			slime.turn_evil()
			spooky.playing = true
			music_animation.play("happy_to_spooky")
			in_walls.toggle_exists()
			out_walls.toggle_exists()
			slime.slime_speed = 3.0


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("debug"):
		stage_change(stage+1)


func _on_slime_target_reached() -> void:
	pass

func _handle_dialog_finished() -> void:
	stage_change(stage+1)
