extends KinematicBody2D


export var direction = 1

func _ready():
	print(direction)

func _process(delta):
	position.x += 10 * direction
	
func bounce():
	$AnimatedSprite.play("Hit")


func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "Hit":
		queue_free()

func ouch(posx):
	print(posx)
	
func take_damage(amt):
	print (amt)
