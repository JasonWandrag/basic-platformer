extends Button


func _on_PlayButton_pressed():
	$SoundButton.play()
	get_tree().change_scene("res://Level1.tscn")
