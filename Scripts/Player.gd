extends CharacterBody2D

var rotation_speed = 2.0  # Adjust as needed
var rotation_offset = Vector2(100, 0)
var speed
var character
var input_direction
var audioPlayer
var health
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

var enemies_killed = 0
var total_xp = 0

signal update_stats

# Called when the node enters the scene tree for the first time.
func _ready():
	audioPlayer = $AudioStreamPlayer2D
	audio_paths.shuffle()
	play_audio(audio_paths[0])
	#connect("update_stats", self, "_on_update_stats")
	pass

func loader(boundaries):
	character = $Character
	speed = character.get_speed()
	rotationNode = $Sprite2D
	health = character.get_health()
	update_health_text()

func getRotation():
	return character.getRotation()

func _process(delta):
	pass

func get_input():
	if runByMouse:
		var mouse_position = get_global_mouse_position()
		input_direction = (mouse_position - global_position).normalized()
		velocity = input_direction * speed
	else:
		input_direction = Input.get_vector("left", "right", "up", "down")
		velocity = input_direction * speed

func _physics_process(delta):
	get_input()
	move_and_slide()
	if runByMouse:
		animationByMouse()
	rotate_to_mouse()

func rotate_to_mouse():
	var mouse_position = character.get_global_mouse_position()
	var direction = (mouse_position - global_position).normalized()
	if direction.length_squared() > 0:
		var rotation_angle = -direction.angle_to(Vector2.RIGHT)
		rotationNode.rotation = rotation_angle
		rotationNode.position = rotation_offset.rotated(rotation_angle)

func animationByMouse():
	var mouse_position = get_global_mouse_position()
	var direction = (mouse_position - global_position).normalized()
	var angle = direction.angle() * 180 / PI
	var current_sector = ""

	if angle > -45 and angle <= 45:
		current_sector = "right"
	elif angle > 45 and angle <= 135:
		current_sector = "down"
	elif angle > 135 or angle <= -135:
		current_sector = "left"
	else:
		current_sector = "up"
	
	if current_sector != last_direction_sector:
		last_direction_sector = current_sector
		match current_sector:
			"right":
				character.playAnimationSide(true)
			"down":
				character.playAnimationBack()
			"left":
				character.playAnimationSide(false)
			"up":
				character.playAnimationUp()

func _input(event):
	if Input.is_action_pressed("up"):
		character.playAnimationUp()
	elif Input.is_action_pressed("down"):
		character.playAnimationBack()
	elif Input.is_action_pressed("left"):
		character.playAnimationSide(false)
	elif Input.is_action_pressed("right"):
		character.playAnimationSide(true)
	elif Input.is_action_pressed("switchmouse"):
		runByMouse = !runByMouse
	elif runByMouse:
		pass
	else:
		character.stopAnimation()

func play_audio(path: String):
	audioPlayer.stop()
	audioPlayer.stream = load(path)
	audioPlayer.play()

func _on_audio_stream_player_2d_finished():
	audio_paths.shuffle()
	play_audio(audio_paths[0])
	pass

func enemycounter(number, xp):
	enemies_killed += number
	total_xp += xp
	emit_signal("update_stats")

func _on_update_stats():
	$EnemyCounter.text = str(enemies_killed)
	$XPCounter2.text = str(total_xp)

func take_damage(amount):
	health -= amount
	update_health_text()
	if health <= 0:
		get_tree().change_scene_to_file("res://Worlds/game_over.tscn")

func update_health_text():
	$HealthCounter.text = str(health)
