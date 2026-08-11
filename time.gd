extends Label

@onready var timer_label : Label = %Time
var elapsed_time : float = 0.0
var is_running : bool = false
 
# Called when the node enters the scene tree for the first time.
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
		
		timer_label.text = str("TIME") + "\n%02d:%02d" % [minutes, seconds]
