extends Node2D


# Called when the node enters the scene tree for the first time.
var Player
var World
var EnemyTypes
var difficulty
var boundries = null
var enemyScene = preload("res://Enemies/base_enemy.tscn") 
signal enemiy_died(xp)

func _ready():
	# initiating the player
	Player = find_child("Player")
	print(Player)
	const player_character_path = "res://PlayerCharacters/hero.tscn"
	var player_character = preload(player_character_path).instantiate()
	player_character.name = "Character"
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
		boundries = [-1000, 1000, -600, 600]
	Player.loader(boundries)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func randomVector() -> Vector2:
	var viewport_bounds = Player.get_viewport_bounds()
	var sides = ["top", "bottom", "left", "right"]
	var side = sides[randi() % sides.size()]

	match side:
		"top":
			return Vector2(randf_range(viewport_bounds.position.x, viewport_bounds.position.x + viewport_bounds.size.x), viewport_bounds.position.y)
		"bottom":
			return Vector2(randf_range(viewport_bounds.position.x, viewport_bounds.position.x + viewport_bounds.size.x), viewport_bounds.position.y + viewport_bounds.size.y)
		"left":
			return Vector2(viewport_bounds.position.x, randf_range(viewport_bounds.position.y, viewport_bounds.position.y + viewport_bounds.size.y))
		"right":
			return Vector2(viewport_bounds.position.x + viewport_bounds.size.x, randf_range(viewport_bounds.position.y, viewport_bounds.position.y + viewport_bounds.size.y))
	return Vector2(0, 0)
func _on_timer_timeout():
	var new_enemy = enemyScene.instantiate()
	var new_position = randomVector()

	while is_within_viewport(new_position, Player.get_viewport_rect()):
		new_position = randomVector()
	new_enemy.position = new_position
	new_enemy.connect("died", Callable(self, "_on_enemy_died"))
	add_child(new_enemy)
	pass # Replace with function body.
	
func _on_enemy_died(xp):
	Player.enemycounter(1, xp)
	

func is_within_viewport(position: Vector2, viewport_rect: Rect2) -> bool:
	return viewport_rect.has_point(position)
