extends Node2D
var rotation_speed = 2.0  # Adjust as needed
var rotation_offset = Vector2(50, 0) 
var sprite
var base_damage = 1
var speed = 400
var cooldown = 10

var inArea = []

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite = get_child(0)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	# Get the mouse position in global coordinates
	var mouse_position = get_global_mouse_position()
	
	# Update the position of the mouse-following node
	$MousePosition.position = mouse_position
	
	# Calculate direction vector from player to mouse position
	var direction = (mouse_position - global_position).normalized()
	
	# Calculate rotation angle based on direction
	var rotation_angle = -direction.angle_to(Vector2.RIGHT)
	
	# Apply rotation to the rotation node
	$RotationNode.rotation = rotation_angle

	# Adjust the position of the rotation node relative to player
	$RotationNode.position = rotation_offset.rotated(rotation_angle)
	
	pass
	
func getRotation():
	return $RotationNode.rotation
func get_speed():
	return speed
	
func playAnimationUp():
	sprite.playAnimationUp()
func stopAnimation():
	sprite.stopAnimation()
func playAnimationBack():
	sprite.playAnimationBack()
func playAnimationSide(flip):
	sprite.playAnimationSideWays(flip)



func _on_rotation_node_area_entered(area):
	var enemy = area.get_parent()

	if enemy not in inArea:
		inArea.append(enemy)
	# enemy = getnodeinarea
	# inArea += enemy (add to array)
	pass # Replace with function body.

func _on_rotation_node_area_exited(area):
	var enemy = area.get_parent()
	if enemy in inArea:
		inArea.erase(enemy)
	# get the node that exited
	# remove from inArea Array
	pass # Replace with function body.


func _on_timer_timeout():
	cooldown -= 1
	for enemy in inArea:
		if enemy.has_method("take_damage"):
			enemy.take_damage(base_damage)
	# get all nodes in inArea array
	# call getDamage Function of those nodes with value of baseDamage Var
	pass # Replace with function body.

func dash():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	get_parent().position += input_direction * 350
	cooldown = 10

func _on_area_2d_area_entered(area):
	if (area.name == "RotationNode"):
		return
	get_parent().take_damage()
	pass # Replace with function body.

func isPlayer():
	return true 
func _input(event):
	if (Input.is_action_pressed("SpecialMoveOne") && cooldown <= 0):
		dash()
