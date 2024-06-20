extends BTLeaf


var charge_direction : Vector2 = Vector2.ZERO
@export var fail_distance_threshold := 500
@export var attack_threshold := 100

func tick(_delta: float, _actor: Node, _blackboard: Blackboard) -> BTStatus:
	var actor_pos := _blackboard.get_value("ally_positions")[_actor.get_instance_id()] as Vector2
	var monster_pos := _blackboard.get_value("monster_position") as Vector2
	if actor_pos.distance_to(monster_pos) > fail_distance_threshold:
		_blackboard.get_value("ally_blackboards")[_actor.get_instance_id()].set_value("movement_input", Vector2.ZERO)
		return BTStatus.FAILURE
	if actor_pos.distance_to(monster_pos) < attack_threshold:
		_blackboard.get_value("ally_blackboards")[_actor.get_instance_id()].set_value("movement_input", Vector2.ZERO)
		return BTStatus.SUCCESS
	var direction = (monster_pos - actor_pos).normalized()
	charge_direction += direction * 0.1
	charge_direction = charge_direction.normalized()
	_blackboard.get_value("ally_blackboards")[_actor.get_instance_id()].set_value("movement_input", direction)
	return BTStatus.RUNNING
