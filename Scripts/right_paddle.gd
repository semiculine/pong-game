extends CharacterBody2D
const SPEED = 400.0
@onready var fixed_x := global_position.x

# Called every frame. 'delta' is the elapsed time since the previous frame
func _physics_process(delta: float) -> void:
	print("Right paddle velocity: ", velocity)
	velocity.y = 0 # Keep the paddle from moving forever 
	# Get the input direction and handle the movement.
	if Input.is_action_pressed("ui_up"):
		velocity.y =  -SPEED
	elif Input.is_action_pressed("ui_down"):
		velocity.y = SPEED
	move_and_slide()
	
	global_position.x = fixed_x
