extends CharacterBody2D

var rotation_speed = 2.0  # Adjust as needed
var rotation_offset = Vector2(100, 0)
var speed
var character_data
var input_direction
var audioPlayer
var health
var runByMouse = true
var rotationNode
var last_direction_sector = ""

var enemies_killed = 0
var total_xp = 0

signal update_stats

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
	audioPlayer = $AudioStreamPlayer2D
	audio_paths.shuffle()
	play_audio(audio_paths[0])
	load_character_data("Hero") # Replace "Hero" with the character name from your JSON

func load_character_data(character_name):
	# Load JSON data
	var file = File.new()
	if file.file_exists("res://data/game_data.json"):
		file.open("res://data/game_data.json", File.READ)
		var game_data = parse_json(file.get_as_text())
		file.close()

		for character in game_data["characters"]:
			if character["name"] == character_name:
				character_data = character
				break

	if character_data:
		speed = character_data["speed"]
		health = character_data["health"]
		rotationNode = $Sprite2D
		$Sprite2D.texture = load(character_data["sprite"]) # Load the sprite from the JSON path
		load_animations(character_data["animations"]) # Load animations from JSON data
		update_health_text()
	else:
		print("Character data not found!")

func load_animations(animation_data):
	# You can load animations based on JSON data here
	# Example: loading an animation from a path
	# Assuming you have an AnimationPlayer node
	var animation_player = $AnimationPlayer
	for anim_name in animation_data:
		var anim_resource = load(animation_data[anim_name])
		animation_player.add_animation(anim_name, anim_resource)

func getRotation():
	return character_data.get("rotation", 0) # Adjust as needed

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
	var mouse_position = get_global_mouse_position()
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
				play_animation("side", true)
			"down":
				play_animation("back")
			"left":
				play_animation("side", false)
			"up":
				play_animation("up")

func play_animation(direction: String, flip: bool = false):
	$Sprite2D.flip_h = flip
	var anim_name = direction
	$AnimationPlayer.play(anim_name)

func _input(event):
	if Input.is_action_pressed("up"):
		play_animation("up")
	elif Input.is_action_pressed("down"):
		play_animation("back")
	elif Input.is_action_pressed("left"):
		play_animation("side", false)
	elif Input.is_action_pressed("right"):
		play_animation("side", true)
	elif Input.is_action_pressed("switchmouse"):
		runByMouse = !runByMouse
	elif runByMouse:
		pass
	else:
		$AnimationPlayer.stop()

func play_audio(path: String):
	audioPlayer.stop()
	audioPlayer.stream = load(path)
	audioPlayer.play()

func _on_audio_stream_player_2d_finished():
	audio_paths.shuffle()
	play_audio(audio_paths[0])

func enemycounter(number, xp):
	enemies_killed += number
	total_xp += xp
	$EnemyCounter.updateText(enemies_killed)
	$XPCounter2.updateText(total_xp)

func take_damage(amount):
	health -= amount
	update_health_text()
	if health <= 0:
		get_tree().change_scene_to_file("res://Worlds/game_over.tscn")

func update_health_text():
	$HealthCounter.updateText(health)

func get_viewport_bounds() -> Rect2:
	var viewport = get_viewport_rect()
	var offset = get_viewport().get_canvas_transform().get_origin()
	viewport.position += offset
	return viewport
