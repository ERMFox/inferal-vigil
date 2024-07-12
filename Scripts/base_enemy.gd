extends CharacterBody2D

var hp = 1
var speed = 100
var xp = 10
var player_position: Vector2
var damage = 10
signal died

func _ready():
	player_position = Vector2()

func _physics_process(delta):
	var player = get_node_or_null("../Player")
	if player:
		player_position = player.global_position
		move_towards_player(delta)
		rotate_towards_player(delta)
	if hp <= 0:
		die()

func move_towards_player(delta):
	var direction = (player_position - global_position).normalized()
	global_position += direction * speed * delta

func rotate_towards_player(delta):
	var direction = (player_position - global_position).normalized()
	if direction.length_squared() > 0:
		var target_rotation = atan2(direction.y, direction.x)
		rotation = lerp_angle(rotation, target_rotation + PI / 2, 1 * delta)

func take_damage(amount):
	hp -= amount

func die():
	emit_signal("died", xp)
	queue_free()

func get_xp() -> int:
	return xp

func get_hp() -> int:
	return hp 

func get_speed() -> int:
	return speed

func get_damage() -> int:
	return damage
