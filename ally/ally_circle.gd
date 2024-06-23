extends BTLeaf

## Determines the distance from the target that the unit will circle around
@export var circle_radius := 100
## Determines the direction the unit will circle around the target: 1 for clockwise, -1 for counter-clockwise
var circle_direction := 1
@export var min_behaviour_time : float = 2.0
@export var max_behaviour_time : float = 8.0
var direction : Vector2 = Vector2.ZERO
@onready var behaviour_timer : Timer = Timer.new()
var active := false

func _ready():
	behaviour_timer.set_wait_time(min_behaviour_time)
	behaviour_timer.set_one_shot(true)
	behaviour_timer.timeout.connect(_on_behaviour_timer_timeout)
	add_child(behaviour_timer)


# Gets called every tick of the behavior tree
func tick(_delta: float, _actor: Node, _blackboard: Blackboard) -> BTStatus:
	if behaviour_timer.is_stopped() and not active:
		behaviour_timer.wait_time = randf_range(min_behaviour_time, max_behaviour_time)
		behaviour_timer.start()
		active = true
		circle_direction = -1 if randf() <= 0.5 else 1
	elif behaviour_timer.is_stopped() and active:
		active = false
		%AttackLimiter.reset(_actor, _blackboard)
		return BTStatus.SUCCESS

	var actor_position := _blackboard.get_value("ally_positions")[_actor.get_instance_id()] as Vector2
	var target_position := _blackboard.get_value("monster_position") as Vector2
	# var distance := actor_position.distance_to(target_position)
	var circle_location = target_position.direction_to(actor_position) * circle_radius
	var direction_to_circle = (circle_location - actor_position).normalized()
	if actor_position.distance_to(circle_location) > circle_radius / 5.0:
		direction = direction_to_circle
	else:
		direction = actor_position.direction_to(target_position).orthogonal() * circle_direction
	direction = direction.normalized()
	_blackboard.get_value("ally_blackboards")[_actor.get_instance_id()].set_value("movement_input", direction)
	return BTStatus.RUNNING


func _on_behaviour_timer_timeout():
	# active = false
	pass
