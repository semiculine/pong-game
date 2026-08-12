class_name MatchTimer
extends Label

@onready var timer_label : Label = %Time
var elapsed_time : float = 0.0
var is_running : bool = false

func _ready() -> void:
	elapsed_time = 0.0
	is_running = true
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_running:
		elapsed_time += delta
		var total_seconds : int = int(elapsed_time)
		var minutes : int = total_seconds / 60
		var seconds : int = total_seconds % 60
		
		timer_label.text = str("T I M E") + "\n%02d:%02d" % [minutes, seconds]

func paused() -> void:
	is_running = false

func reset() -> void:
	elapsed_time = 0.0
	is_running = true
