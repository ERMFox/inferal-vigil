extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#self.position = get_parent().get_position_delta() + Vector2(50, 0)
	self.rotation = get_parent().getRotation() - 80
	pass
