extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func playAnimationUp():
	play("Up")
func stopAnimation():
	stop()
func playAnimationBack():
	play("back")
func playAnimationSideWays(flip):
	if (!flip):
		flip_h = true
	else:
		flip_h = false
	play("sideways")
