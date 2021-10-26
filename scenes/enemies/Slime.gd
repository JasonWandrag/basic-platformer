extends KinematicBody2D

export var direction = 1
export var detects_cliffs = true
var velocity = Vector2(0,0)
var speed = 50
var dead = false
const GRAVITY = 50
const JUMPFORCE = -850

func _ready():
	$AnimatedSprite.set_offset(Vector2(-32,0))
	if direction == -1:
		$AnimatedSprite.flip_h = true
	$floor_checker.position.x = $CollisionShape2D.shape.get_extents().x * -direction
	$floor_checker.enabled = detects_cliffs
	if not detects_cliffs:
		set_modulate(Color(1.2,0.5,1))

func _physics_process(delta):
	# THIS IS FOR GRAVITY TO HAPPEN
	velocity.y = velocity.y + GRAVITY
	velocity.x = speed * direction
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if is_on_wall() or not $floor_checker.is_colliding() and detects_cliffs and is_on_floor():
		$floor_checker.position.x = $CollisionShape2D.shape.get_extents().x * -direction
		direction = direction * -1
		$AnimatedSprite.set_offset(Vector2(32 * direction,0))
		$AnimatedSprite.flip_h = not $AnimatedSprite.flip_h

func _on_top_checker_body_entered(body):
	set_modulate(Color(1.2,0.5,1))
	$AnimatedSprite.play("MonsterDeath")
	$SoundSquash.play()
	speed = 0
	set_collision_layer_bit(4, false)
	set_collision_mask_bit(0, false)
	$top_checker.set_collision_layer_bit(4, false)
	$top_checker.set_collision_mask_bit(0, false)
	$sides_checker.set_collision_layer_bit(4, false)
	$sides_checker.set_collision_mask_bit(0, false)
	$Timer.start()
	body.bounce()

func _on_sides_checker_body_entered(body):
	body.ouch(position.x)
	body.take_damage(50)

func _on_Timer_timeout():
	queue_free()

func _on_sides_checker_area_entered(area):
	if area.is_in_group("sword"):
		velocity.y = JUMPFORCE * 0.5
		speed = 500
		if area.get_child(0).position.x < 1:
			direction = -1
		else:
			direction = 1
		velocity.x = speed * direction
		set_modulate(Color(1.2,0.5,1))
		dead = true
		$AnimatedSprite.play("MonsterDeath")
		$SoundSquash.play()
#		speed = 0
		set_collision_layer_bit(4, false)
		set_collision_mask_bit(0, false)
		$top_checker.set_collision_layer_bit(4, false)
		$top_checker.set_collision_mask_bit(0, false)
		$sides_checker.set_collision_layer_bit(4, false)
		$sides_checker.set_collision_mask_bit(0, false)
		$Timer.start()
