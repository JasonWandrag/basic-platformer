extends RigidBody2D

var selected = false

func _on_Area2D_input_event(viewport, event, shape_idx):
	if Input.is_action_pressed("click"):
		selected = true
		
func _physics_process(delta):
	if Input.is_action_just_released("click"):
		selected = false
	if selected:
		global_position = lerp(global_position, get_global_mouse_position(), 25 * delta)
