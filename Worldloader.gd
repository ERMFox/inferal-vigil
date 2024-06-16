extends Node2D


# Called when the node enters the scene tree for the first time.
var Player
var World
var EnemyTypes
var difficulty
var boundries = null
func _ready():
	# initiating the player
	Player = find_child("Player")
	print(Player)
	const player_character_path = "res://PlayerCharacters/hero.tscn"
	var player_character = preload(player_character_path).instantiate()
	Player.add_child(player_character)
	# initiating the scene
	#var scene_path = self.scene_data if self.scene_data else "res://Worlds/grasslands.tcsn"
	#var loaded_scene = load(scene_path)
	#self.add_child(loaded_scene)
	# initiating world settings
	#World = $World
	#EnemyTypes = World.getEnemyTypes()
	#difficulty = World.getDifficulty()
	#boundries = world.getsize (should return a array of boundries)
	if (!boundries):
		boundries = [-500, 500, -300, 300]
	Player.loader(boundries)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
