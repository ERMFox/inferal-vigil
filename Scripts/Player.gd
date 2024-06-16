extends CharacterBody2D

var speed
var character
var input_direction
var min_x
var min_y
var max_x
var max_y
var audioPlayer
var audio_paths = [
	"res://Music/Galactic Rap.mp3",
	"res://Music/Mesmerizing Galaxy Loop.mp3",
	"res://Music/SCP-x5x.mp3",
	"res://Music/SCP-x6x.mp3",
	"res://Music/SCP-x5x.mp3"
	# Add more paths as needed
]

# Called when the node enters the scene tree for the first time.
func _ready():
	audioPlayer = get_child(1)
	audio_paths.shuffle()
	play_audio(audio_paths[0])
	pass # Replace with function body.

func loader(boundries):
	character = get_child(2)
	speed = character.get_speed()
	var parent = get_parent()
	min_x = boundries[0]
	min_y = boundries[2]
	max_x = boundries[1]
	max_y = boundries[3]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var pos = position
	pos.x = clamp(pos.x, min_x, max_x)
	pos.y = clamp(pos.y, min_y, max_y)
	position = pos
	pass
func get_input():
	input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed
func _physics_process(delta):
	get_input()
	move_and_slide()
func _input(event):
	if (Input.is_action_pressed("up")):
		character.playAnimationUp()
	elif (Input.is_action_pressed("down")):
		character.playAnimationBack()
	elif (Input.is_action_pressed("left")):
		character.playAnimationSide(false)
	elif (Input.is_action_pressed("right")):
		character.playAnimationSide(true)
	else:
		character.stopAnimation()

func play_audio(path: String):
	audioPlayer.stop()  # Stop any currently playing audio
	var audio_resource = load(path)
	audioPlayer.stream = audio_resource
	audioPlayer.play()

func _on_audio_stream_player_2d_finished():
	audio_paths.shuffle()
	play_audio(audio_paths[0])
	pass # Replace with function body.
