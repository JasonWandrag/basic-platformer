extends RigidBody2D

export var treasure_type = "BronzeTreasure"

func _ready():
	$AnimatedSprite.play(treasure_type + "Treasure")
