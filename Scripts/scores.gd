extends Control

@onready var player_score_label: Label = %PlayerScore
@onready var computer_score_label: Label = %ComputerScore
@export var ball : CharacterBody2D

var player_score: int 
var computer_score: int
var winning_point: int = 11

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_score = 0
	computer_score = 0
	update_score()

# Refreshes UI labels
func update_score() -> void:
	player_score_label.text = str(player_score)
	computer_score_label.text = str(computer_score)

# Called whenever a goal emits the 'points_scored' signal
# Debug note: initially, scores.gd was connected to the player and computer score labels separately,
# creating multiple copies of the script running on different nodes. to fix this, I moved scores.gd
# to the ScoreTracker control node so there is only one instance where the score is keeping track
func _on_goal_point_scored(is_left_goal : bool) -> void:
	if is_left_goal:
		player_score += 1
	else:
		computer_score += 1
	print("Computer Score: ", computer_score, "; Player Score: ", player_score)
	
	update_score()
	# Get ball node and reset speed/position
	var ball = get_tree().get_first_node_in_group("Ball")
	if ball:
		# Send ball towards the player who was just scored on
		var launch_dir = 1.0 if is_left_goal else -1.0
		ball.reset_ball(launch_dir)
		
	
	_end_game()
	
func _end_game() -> void:
	if player_score >= winning_point or computer_score >= winning_point:
		# Reset score
		player_score = 0
		computer_score = 0
		update_score()
		
		var ball = get_tree().get_first_node_in_group("Ball")
		if ball:
			ball.velocity = Vector2.ZERO

		# Trigger "Play Again" Screen
	pass
