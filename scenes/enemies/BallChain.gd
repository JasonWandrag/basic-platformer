extends KinematicBody2D

# Enemy Settings
export var direction = 1
var gravity = 10
var velocity = Vector2(0, 0)
var speed = 64
var is_moving_right = true
const JUMPFORCE = -850

# Ready
func _ready():
	$AnimatedSprite.play("Run")


func _process(delta):
#	if $AnimatedSprite.animation == "Attack":
#		return
	move_character();
	detect_turn_around()

func move_character():
	velocity.x = speed if is_moving_right else -speed;
	velocity.y += gravity;
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
func detect_turn_around():
	if not $RayCast2D.is_colliding() and is_on_floor():
		is_moving_right = !is_moving_right
		scale.x = -scale.x

func atk():
	$EnemyAtkArea.monitoring = true

func end_of_atk():
	$EnemyAtkArea.monitoring = false
	
func start_walk():
	$AnimatedSprite.play("Run")
	speed = 64


func _on_PlayerDetectorArea_body_entered(body):
	speed = 0
	$AnimatedSprite.play("ChargeTransition")
	


func _on_EnemyAtkArea_body_entered(body):
#	get_tree().change_scene("res://LoseScreen.tscn")
	body.take_damage(30)
	body.ouch(position.x)


func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "Attack":
		end_of_atk()
		start_walk()
	elif $AnimatedSprite.animation == "ChargeTransition":
		$AnimatedSprite.play("Charge")
	elif $AnimatedSprite.animation == "Charge":
		$AnimatedSprite.play("Attack")
		atk()

func ouch():
	pass



func _on_SidesChecker_area_entered(area):
	if area.is_in_group("sword"):
		velocity.y = JUMPFORCE * 0.2
		speed = 150
		if area.get_child(0).position.x < 1:
			direction = -1
		else:
			direction = 1
		velocity.x = speed * direction
		$AnimatedSprite.play("Death")
		$Timer.start()
		


func _on_Timer_timeout():
	queue_free()
