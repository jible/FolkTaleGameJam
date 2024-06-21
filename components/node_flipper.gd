class_name NodeFlipper extends Node2D


## The velocity source that will inform this node when to flip the targets.
@export var source : CharacterBody2D
## The targets to flip when the velocity flips signs
@export var targets : Array[Node2D]
@export_category("Configuration")
@export_group("Thresholds")
@export var flip_time_threshold : float = 0.1
@export var flip_speed_threshold : float = 5
@export_group("Axes to Flip")
@export var x_axis := true
@export var y_axis := false
var flip_timer : Timer


func _ready():
	assert(targets, "Target not set in NodeFlipper")
	flip_timer = Timer.new()
	flip_timer.one_shot = true
	flip_timer.autostart = false
	flip_timer.wait_time = flip_time_threshold
	flip_timer.timeout.connect(func(): print("Timeout"))
	add_child(flip_timer)

func _process(_delta):
	if abs(source.velocity.x) < flip_speed_threshold or not flip_timer.is_stopped():
		return
	if source.velocity.x < 0:
		targets.map(func(e): 
			e.scale.x = -abs(e.scale.x)
		)
		flip_timer.start()
	elif source.velocity.x > 0:
		targets.map(func(e): 
			e.scale.x = abs(e.scale.x)
		)
		flip_timer.start()
