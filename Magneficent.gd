extends KinematicBody2D

onready var bullet = preload("res://scenes/items/EnergyBall.tscn")
var b
var velocity = Vector2(0,0)
var touch_ground = true
var knocked_back = false
var is_attacking = false
var direction = 1
var health = 80
const SPEED = 200
const GRAVITY = 30
const JUMPFORCE = -850


func _physics_process(delta):
	if Input.is_action_pressed("right") and not is_attacking:
		velocity.x = SPEED
		direction = 1
		$AttackArea/AttackCollision.position.x = 36
		if is_on_floor():
			$Sprite.play("WarriorRun")
		$Sprite.flip_h = false
	elif Input.is_action_pressed("left") and not is_attacking:
		velocity.x = -SPEED
		direction = -1
		$AttackArea/AttackCollision.position.x = -36
		if is_on_floor():
			$Sprite.play("WarriorRun")
		$Sprite.flip_h = true
	elif is_on_floor() and not knocked_back:
		if not is_attacking:
			$Sprite.play("WarriorIdle")
	
	shoot()
	
	$AttackArea/AttackCollision.disabled = true
	if Input.is_action_just_pressed("attack"):
		$Sprite.play("WarriorAtk1")
		is_attacking = true
		$AttackArea/AttackCollision.disabled = false
	
	if not is_on_floor() and not knocked_back:
		if touch_ground == true:
			touch_ground = false
			$Sprite.play("WarriorJump")
	else:
		touch_ground = true
	
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMPFORCE
		$SoundJump.play()
	
	# THIS IS FOR GRAVITY TO HAPPEN
	velocity.y = velocity.y + GRAVITY
	velocity = move_and_slide(velocity, Vector2.UP)
	
	velocity.x = lerp(velocity.x, 0, 0.3)

func _on_fallzone_body_entered(body):
	get_tree().change_scene("res://LoseScreen.tscn")


func bounce():
	velocity.y = JUMPFORCE * 0.5
	
func ouch(var posx):
	knocked_back = true
	
#	set_modulate(Color(1,0.3,0.3,0.3))
	bounce()
	if position.x < posx:
		velocity.x = -800
	elif position.x > posx:
		velocity.x = 800
		$Sprite.flip_h = true
		
	Input.action_release("left")
	Input.action_release("right")


func _on_Timer_timeout():
	get_tree().change_scene("res://LoseScreen.tscn")


func _on_Sprite_animation_finished():
	if $Sprite.animation == "WarriorAtk1":
		$AttackArea/AttackCollision.disabled = true
		is_attacking = false
	if $Sprite.animation == "WarriorHit":
		knocked_back = false
	if $Sprite.animation == "WarriorDeath":
		$Sprite.stop()
	if $Sprite.animation == "WarriorAtk2":
		is_attacking = false

func take_damage(amt):
	$Sprite.play("WarriorHit")
	$SoundOuch.play()
	health = health - amt
	if health <= 0:
		$Sprite.play("WarriorDeath")
		$Timer.start()

func shoot():
	if Input.is_action_just_pressed("shoot"):
		$Sprite.play("WarriorAtk2")
		is_attacking = true
		b = bullet.instance()
		print(b)
		b.set("direction", direction)
		get_parent().add_child(b)
		b.global_position = $Position2D.global_position	
