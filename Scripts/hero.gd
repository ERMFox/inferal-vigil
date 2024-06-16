extends Node2D

var sprite
# Called when the node enters the scene tree for the first time.
func _ready():
	sprite = get_child(0)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
func get_speed():
	return 400
	
func playAnimationUp():
	sprite.playAnimationUp()
func stopAnimation():
	sprite.stopAnimation()
func playAnimationBack():
	sprite.playAnimationBack()
