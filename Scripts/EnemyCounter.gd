extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	updateText(0)
	pass # Replace with function body.
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func updateText(count):
	self.text = "Enemies Killed: %d" %count
