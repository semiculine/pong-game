extends CharacterBody2D

@export var SPEED : float = 400.0
@export var lead_time : float = -0.2
@export var top_limit_y : float = 65
@export var bottom_limit_y : float = 650.0
@onready var fixed_x := global_position.x
@onready var ball = $"/root/Main/Ball!"

func _ready():
	print(ball)
	if not ball:
		ball = get_tree().get_node("Ball!")

# Called every frame. 'delta' is the elapsed time since the previous frame
@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	var target_y : float = global_position.y
	
	if is_instance_valid(ball):
		if ball.velocity.x < 0: # when ball is heading towards left paddle
			# Predict where the ball will be in t seconds via lead_time
			var predicted_ball_y = ball.global_position.y + (ball.velocity.y * lead_time) 
			target_y = clamp(predicted_ball_y, top_limit_y, bottom_limit_y)
		
		else: # Glide towards the center of the screen when ball is moving towards right paddle
			target_y = (top_limit_y + bottom_limit_y) / 2.0
			
		var y_difference = target_y - global_position.y
		# Small deadzone (10px) to stop jittering when aligned
		if abs(y_difference) > 10.0:
			# Move toward target without exceeding max SPEED
			velocity.y = move_toward(velocity.y, sign(y_difference) * SPEED, 2000.0 * delta)
		else:
			velocity.y = move_toward(velocity.y, 0, 2000.0 * delta)
	else: 
		velocity.y = 0.0
		
	move_and_slide()
	global_position.x = fixed_x
