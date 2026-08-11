
extends Area2D

# Define a signal that passes whether the ball entered the left goal
signal point_scored(is_left_goal : bool)
@export var is_left_goal : bool = true

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Ball"):
		print("Goal!")
		point_scored.emit(is_left_goal) # Merely emit
		#reset_ball(body)

#func reset_ball(ball: Node2D) -> void:
#	ball.global_position = Vector2(577,344) # Center coordinates of board
#	ball.velocity = ball.initial_velocity
