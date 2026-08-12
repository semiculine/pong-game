extends Control

# Configure on-screen UI
@onready var match_timer : MatchTimer = %Time
@onready var game_over_panel : Control = $GameOverPanel
@onready var winner_label : Label = $GameOverPanel/WinnerText
@onready var play_again_button : Button = $GameOverPanel/PlayAgainButton
@onready var button_sound : AudioStreamPlayer2D = $ButtonSound
# Score and sound initilization
@onready var goal_sound : AudioStreamPlayer2D = $GoalSound
@onready var player_score_label: Label = %PlayerScore
@onready var computer_score_label: Label = %ComputerScore
@export var ball : CharacterBody2D

var player_score: int 
var computer_score: int
var winning_point: int = 11

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_score = 0
	computer_score = 10
	update_score()
	
	# Hide Game over overlay on start & connect button signal
	game_over_panel.visible = false
	play_again_button.pressed.connect(_on_play_again_pressed)


# Refreshes UI labels
func update_score() -> void:
	player_score_label.text = str(player_score)
	computer_score_label.text = str(computer_score)

# Called whenever a goal emits the 'points_scored' signal
# Debug note: initially, scores.gd was connected to the player and computer score labels separately,
# creating multiple copies of the script running on different nodes. to fix this, I moved scores.gd
# to the ScoreTracker control node so there is only one instance where the score is keeping track
func _on_goal_point_scored(is_left_goal : bool) -> void:
	# Get ball node and reset speed/position
	var ball = get_tree().get_first_node_in_group("Ball")
	
	if is_left_goal:
		player_score += 1
		if ball:
			ball.reset_ball(-1.0) # Send ball towards computer
	else:
		computer_score += 1
		if ball:
			ball.reset_ball(1.0) # Send ball towards player
	goal_sound.play()
	print("Computer Score: ", computer_score, "; Player Score: ", player_score)
	
	update_score()
	_end_game()
	
func _end_game() -> void:
	if player_score >= winning_point or computer_score >= winning_point:
		# Pause timer
		match_timer.paused()
		
		# Declare winner via test
		if player_score >= winning_point:
			winner_label.text = "PLAYER WINS!"
		else: 
			winner_label.text = "COMPUTER WINS!"
		update_score()
		
		var ball = get_tree().get_first_node_in_group("Ball")
		if ball:
			ball.velocity = Vector2.ZERO
			ball.hide()

		# Trigger Game Over overlay
		game_over_panel.visible = true

func _on_play_again_pressed() -> void:
	button_sound.play()
	# Reset Scores and UI
	player_score = 0
	computer_score = 0
	update_score()
	game_over_panel.visible = false
	match_timer.reset()

	# Get and launch ball
	var ball = get_tree().get_first_node_in_group("Ball")
	if ball:
		ball.show()
		ball.reset_ball()
