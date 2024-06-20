extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.position = get_parent().position - Vector2(120, -5)
	self.rotation = get_parent().rotation - 80
	pass


func _on_timer_timeout():
	play()
	pass # Replace with function body.
