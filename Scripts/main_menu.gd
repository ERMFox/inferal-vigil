extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_quit_button_down():
	var confirmation = $"Confirmation Dialogue"
	confirmation.show()
	pass # Replace with function body.


func _on_confirmation_dialogue_id_pressed(id):
	if id == 1:
		get_tree().quit()
		


func _on_start_game_button_down():
	get_tree().change_scene_to_file("res://base_world.tscn")
	pass # Replace with function body.


func _on_audio_stream_player_2d_finished():
	var audio_player = find_child("AudioStreamPlayer2D")
	audio_player.play()
	pass # Replace with function body.
