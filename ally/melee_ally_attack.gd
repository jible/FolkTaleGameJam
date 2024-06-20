extends BTLeaf


@export var attack_range := 100
@export var fail_distance_threshold := 150

func tick(_delta: float, _actor: Node, _blackboard: Blackboard) -> BTStatus:
	var actor_pos := _blackboard.get_value("ally_positions")[_actor.get_instance_id()] as Vector2
	var monster_pos := _blackboard.get_value("monster_position") as Vector2

	if actor_pos.distance_to(monster_pos) > fail_distance_threshold:
		_blackboard.get_value("ally_blackboards")[_actor.get_instance_id()].set_value("movement_input", Vector2.ZERO)
		return BTStatus.FAILURE
	
	if actor_pos.distance_to(monster_pos) < attack_range:
		# Attack
		var direction = (monster_pos - actor_pos).normalized()
		_blackboard.get_value("ally_blackboards")[_actor.get_instance_id()].set_value("movement_input", Vector2.ZERO)
		return BTStatus.SUCCESS
	else:
		# Move towards the monster
		var direction = (monster_pos - actor_pos).normalized()
		_blackboard.get_value("ally_blackboards")[_actor.get_instance_id()].set_value("movement_input", direction)
	
	return BTStatus.RUNNING
