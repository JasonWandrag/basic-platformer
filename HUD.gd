extends CanvasLayer

var coins = 0;

func _ready():
	$CoinsCounter.text = String(coins)


func _on_coin_collected():
	coins = coins + 1
	$SoundCoin.play()
	_ready()
	if coins == 20:
		get_tree().change_scene("res://WinScreen.tscn")
	
