extends Node3D
@onready var slime: Slime = $Slime
@onready var player: Player = $Player
@onready var end_of_path: Vector3 = $"end of path".position
@onready var start_of_path: Vector3 = $"start of path".position
@onready var i_love_you: Vector3 = $"I love you".position
@onready var dialog_anchor: Control = %DialogAnchor
@onready var stage_label: Label = $CanvasLayer/StageLabel
@onready var music_animation: AnimationPlayer = $MUSIC/music_animation
@onready var happy: AudioStreamPlayer = $MUSIC/Happy
@onready var spooky: AudioStreamPlayer = $MUSIC/Spooky

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
	"Hey buddy! it's so nice out today",
	"Let's go into the woods!",
	"not for a secret confession",
	"or anything like that.."
]

const lines_2: Array[String] = [
	"I love you by the way",
	"that wasn't the secret..",
	"uhh, let's keep going",
]

const lines_3: Array[String] = [
	"Woah something feels weird",
	"ya know...",
	"I am getting really hungry all of a sudden.",
	"and you look very tasty..",
	"C̵̦̾͠O̸̼͂̔M̷̞̞̅̄E̸͈̩̅̑ ̷̰̬͌̔H̸͛̕ͅẼ̵̞̰̚R̸̦̱̕Ē̷͓̼!̸̘̈́͆"
]

var stage: int = 0

func _ready() -> void:
	stage_change(0)
	happy.playing = true
	spooky.playing = false

func _process(_delta: float) -> void:
	stage_label.text = "Stage: %s" % stage
	match stage:
		1:
			if slime.position.distance_to(player.position) >= 15:
				slime.get_player_attention(player.position)
				stage -= 1
				DialogManager.start_dialog(dialog_anchor, lines_catch_up, good_slime)
		3:
			slime.set_next_nav_target(player.position)
			if player.position.distance_to(slime.position) <= 1:
				print("GAME OVER")

func stage_change(new_stage: int) -> void:
	stage = min(new_stage, MAX_STAGE)
	match stage:
		0:
			slime.set_next_nav_target(start_of_path)
		1:
			slime.slime_speed = 5.0
			slime.set_next_nav_target(i_love_you)
		2:
			slime.slime_speed = 7.0
			slime.set_next_nav_target(end_of_path)
		3:
			slime.slime_speed = 3.0


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("debug"):
		stage_change(stage+1)


func _on_slime_target_reached() -> void:
	DialogManager.dialog_finished.connect(_handle_dialog_finished)
	match stage:
		0:
			DialogManager.start_dialog(dialog_anchor, lines_1, good_slime)
		1:
			DialogManager.start_dialog(dialog_anchor, lines_2, good_slime)
		2:
			DialogManager.start_dialog(dialog_anchor, lines_3, spooky_speak)
			slime.turn_evil()
			spooky.playing = true
			music_animation.play("happy_to_spooky")
			
		3:
			pass
			
	

func _handle_dialog_finished() -> void:
	stage_change(stage+1)
