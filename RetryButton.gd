extends Button



func _on_RetryButton_pressed():
	get_tree().change_scene("res://Level1.tscn")
	$SoundButton.play()
