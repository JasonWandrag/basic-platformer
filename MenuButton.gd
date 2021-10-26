extends Button



func _on_MenuButton_pressed():
	$SoundButton.play()
	get_tree().change_scene("res://TitleMenu.tscn")
