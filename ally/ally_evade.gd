extends BTLeaf

## The distance from the target location that upon reaching, will consider the task successful 
@export var distance_threshold := 10
## The minimum distance from the monster still considered safe
@export var monster_safety_distance := 200


func tick(_delta: float, _actor: Node, _blackboard: Blackboard) -> BTStatus:
	var actor_pos := _blackboard.get_value("ally_positions")[_actor.get_instance_id()] as Vector2
	var monster_pos := _blackboard.get_value("monster_position") as Vector2
	if actor_pos.distance_to(monster_pos) > monster_safety_distance:
		return BTStatus.FAILURE

	var safe_pos = _find_nearest_safe_position(_actor, _blackboard)
	if actor_pos.distance_to(safe_pos) <= distance_threshold:
		return BTStatus.SUCCESS
	var direction = (actor_pos - safe_pos).normalized()
	_blackboard.get_value("ally_blackboards")[_actor.get_instance_id()].set_value("movement_input", direction)
	return BTStatus.RUNNING


func _find_nearest_safe_position(_actor: Node, _blackboard: Blackboard) -> Vector2:
	var actor_position := _blackboard.get_value("ally_positions")[_actor.get_instance_id()] as Vector2
	var target_position := _blackboard.get_value("monster_position") as Vector2
	var distance := actor_position.distance_to(target_position)
	var direction := target_position - actor_position
	var safe_position = actor_position + direction.normalized() * max(0, monster_safety_distance - distance)
	return safe_position
