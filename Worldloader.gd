extends Node2D


# Called when the node enters the scene tree for the first time.
var Player
var World
var EnemyTypes
var difficulty
func _ready():
	# initiating the player
	Player = $Player
	var player_character_path = self.player_data if self.player_data else "res://hero.tscn"
	var player_character = load(player_character_path)
	Player.add_child(player_character, "PlayerCharacter")
	# initiating the scene
	var scene_path = self.scene_data if self.scene_data else "res://grasslands"
	var loaded_scene = load(scene_path)
	self.add_child(loaded_scene, "World")
	# initiating world settings
	World = $World
	EnemyTypes = World.getEnemyTypes()
	difficulty = World.getDifficulty()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
