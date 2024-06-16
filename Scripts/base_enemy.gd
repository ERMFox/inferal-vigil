extends CharacterBody2D

var hp = 1
var speed = 100
var xp = 10
var player_position

func _ready():
	pass

func _physics_process(delta):
	player_position = get_parent().find_child("Player").global_position
	var direction = (player_position - global_position).normalized()
	var new_position = global_position + direction * speed * delta
	global_position = new_position
	# rotate to player
	if direction.length_squared() > 0:
		var target_rotation = atan2(direction.y, direction.x)
		rotation = lerp_angle(rotation, target_rotation + 90, 1 * delta)
	pass

func get_xp():
	return xp
func get_hp():
	return hp 
func get_speed():
	return speed
