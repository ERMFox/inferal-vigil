extends CharacterBody2D
var rotation_speed = 2.0  # Adjust as needed
var rotation_offset = Vector2(100, 0)
var speed
var character
var input_direction
var min_x
var min_y
var max_x
var max_y
var audioPlayer
var runByMouse = true
var audio_paths = [
	"res://Music/Galactic Rap.mp3",
	"res://Music/Mesmerizing Galaxy Loop.mp3",
	"res://Music/SCP-x5x.mp3",
	"res://Music/SCP-x6x.mp3",
	"res://Music/SCP-x5x.mp3"
	# Add more paths as needed
]
var rotationNode
var last_direction_sector = ""


# Called when the node enters the scene tree for the first time.
func _ready():
	audioPlayer = get_child(1)
	audio_paths.shuffle()
	play_audio(audio_paths[0])
	pass # Replace with function body.

func loader(boundries):
	character = get_child(3)
	speed = character.get_speed()
	var parent = get_parent()
	rotationNode = get_child(2)
	min_x = boundries[0]
	min_y = boundries[2]
	max_x = boundries[1]
	max_y = boundries[3]
func getRotation():
	return character.getRotation()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var pos = position
	pos.x = clamp(pos.x, min_x, max_x)
	pos.y = clamp(pos.y, min_y, max_y)
	position = pos
	pass
func get_input():
	if runByMouse:
		# Get the global mouse position
		var mouse_position = get_global_mouse_position()
		# Calculate the direction from the character to the mouse
		var input_direction = (mouse_position - global_position).normalized()
		# Set the velocity based on the direction and speed
		velocity = input_direction * speed
	else:
		# Get the input direction from keyboard
		input_direction = Input.get_vector("left", "right", "up", "down")
		# Set the velocity based on the direction and speed
		velocity = input_direction * speed
func _physics_process(delta):
	get_input()
	move_and_slide()
	if (runByMouse):
		animationByMouse()
	var mouse_position = character.get_global_mouse_position()

	# Update the position of the mouse-following node

	
	# Calculate direction vector from player to mouse position
	var direction = (mouse_position - global_position).normalized()
	
	# Calculate rotation angle based on direction
	var rotation_angle = -direction.angle_to(Vector2.RIGHT)
	
	# Apply rotation to the rotation node
	rotationNode.rotation = rotation_angle

	# Adjust the position of the rotation node relative to player
	rotationNode.position = rotation_offset.rotated(rotation_angle)

func animationByMouse():
	var mouse_position = get_global_mouse_position()
	var direction = (mouse_position - global_position).normalized()
	
	# Calculate the angle of the direction vector in degrees
	var angle = direction.angle() * 180 / PI

	var current_sector = ""

	# Determine the sector based on the angle
	if angle > -45 and angle <= 45:
		current_sector = "right"
	elif angle > 45 and angle <= 135:
		current_sector = "down"
	elif angle > 135 or angle <= -135:
		current_sector = "left"
	else:
		current_sector = "up"
	
	# Play the animation only if the sector has changed
	if current_sector != last_direction_sector:
		last_direction_sector = current_sector
		match current_sector:
			"right":
				character.playAnimationSide(true)  # Moving right
			"down":
				character.playAnimationBack()  # Moving down
			"left":
				character.playAnimationSide(false)  # Moving left
			"up":
				character.playAnimationUp()  # Moving up

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

func test():
	print(get_child(0).get_viewport())

func take_damage():
	get_tree().change_scene_to_file("res://Worlds/game_over.tscn")
	pass # Replace with function body.
