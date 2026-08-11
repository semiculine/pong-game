class_name Ball # registers "Ball" as a global type in Godot
extends CharacterBody2D

@export var base_speed : float = 400.0 # Starting speed for new round
@export var speed_increment : float = 50.0 # Speed increase amount
@export var collisions_to_speedup : int = 3 # Speed up every X collisions
@export var follow_speed : float = 30.0

var current_speed : float
var total_collisions : int  # persisten collision tracker

@export var initial_velocity = Vector2(base_speed, 0)

@onready var ball_motion = $CollisionShape2D/BallMotion
@onready var start_position : Vector2 = global_position

func _ready():
	reset_ball()

func reset_ball(direction_x : float = 1.0) -> void:
	global_position = start_position
	current_speed = base_speed
	total_collisions = 0
	
	# Set a fresh velocity vector point left (-1) or right (+1)
	velocity = Vector2(direction_x * current_speed, 0)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
# COLLISION / TRAJECTORY CASES FOR BALL
func _physics_process(delta: float) -> void:
	# Increase ball speed every X collisions
	var collision_count = get_slide_collision_count()
	print("Ball's velocity & angle: ", velocity.x, ", ", velocity.y, ", ", velocity.angle())
	
	# Ball trajectory trail - line interpolation
	if velocity.length() > 0: # Base Case - ball is not moving
		# SMOOTH ROTATION (lerp_angle)
		# Smoothly rotates the trail toward the move direction instead of snapping instantly
		var target_angle = velocity.angle() + deg_to_rad(45)
		ball_motion.rotation = lerp_angle(ball_motion.rotation, target_angle, follow_speed * delta)
		
		# VISUAL LAG / STRETCH EFFECT
		# Offsets sprite slightly backward opposite to move direction, then lerp pulls it back
		var lag_target = -velocity.normalized() * 5.0 # 10px drag distance
		ball_motion.position = ball_motion.position.lerp(lag_target, follow_speed * delta)
	

	#ball_motion.position = ball_motion.position.lerp(Vector2.ZERO, follow_speed * delta)
	
	
	# ASSUME THAT IF THE BALL IS COLLIDING WITH SURFACE AT AN ANGLE AND...
	var collision = move_and_collide(velocity * delta)
	if collision:
		var collider = collision.get_collider()
		var hit_position = global_position.y - collider.global_position.y
		
		total_collisions += 1
		if total_collisions % collisions_to_speedup == 0:
			current_speed += speed_increment
			print("Collision #: ", total_collisions, " -> Speed boosted to: ", current_speed)
		
		# COLLISION WITH PADDLE
		if collider.is_in_group("Paddles"):
			# print("Hit position:", hit_position, "; Ball pos: ", global_position.y, "; Pad pos: ", collider.global_position.y)
			if global_position.x < collider.global_position.x:
				# Bounce left / right, away from paddle based on relative position
				velocity.x = -abs(velocity.x) # Bounce left
			else:
				velocity.x = abs(velocity.x) # Bounce right
			
			velocity.y = 8.0 * hit_position # Control angle intensity
		
		# COLLISION WITH TOP / BOTTOM WALL
		elif collision.get_collider().is_in_group("InvisibleWalls"):
			velocity.y *= -1 # FLIP Y - AXIS
		
		# Enforcing minimum horizontal speed to prevent infinite vertical bouncing loop
		var min_x_speed := 200.0
		if abs(velocity.x) < min_x_speed:
			var dir = sign(velocity.x) if velocity.x != 0 else 1.0 # Similar to something like "condition ? a : b;" in C
			velocity.x = dir * min_x_speed
		
		# Maintain constant overall ball speed
		velocity = velocity.normalized() * current_speed # Essentially <1,1> * initial_speed
