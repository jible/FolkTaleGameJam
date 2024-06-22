extends BTLeaf


var charge_direction : Vector2 = Vector2.ZERO
@export var fail_distance_threshold := 600
@export var attack_threshold := 75
var _just_entered := true

func tick(_delta: float, _actor: Node, _blackboard: Blackboard) -> BTStatus:
	var actor_pos := _blackboard.get_value("ally_positions")[_actor.get_instance_id()] as Vector2
	var monster_pos := _blackboard.get_value("monster_position") as Vector2
	var fsm = _blackboard.get_value("ally_blackboards")[_actor.get_instance_id()].get_value("fsm") as FiniteStateMachine
	
	if actor_pos.distance_to(monster_pos) > fail_distance_threshold:
		_blackboard.get_value("ally_blackboards")[_actor.get_instance_id()].set_value("movement_input", Vector2.ZERO)
		fsm.fire_event("charge_to_move")
		_just_entered = true
		return BTStatus.FAILURE
	elif actor_pos.distance_to(monster_pos) < attack_threshold:
		_blackboard.get_value("ally_blackboards")[_actor.get_instance_id()].set_value("movement_input", Vector2.ZERO)
		fsm.fire_event("attack")
		_just_entered = true
		return BTStatus.SUCCESS
	
	if _just_entered:
		var states = fsm.states as Array
		for state in states:
			if state is ChargeState:
				fsm.change_state(state)
				break
		_just_entered = false

	var direction = (monster_pos - actor_pos).normalized()
	charge_direction = direction
	_blackboard.get_value("ally_blackboards")[_actor.get_instance_id()].set_value("movement_input", direction)
	_blackboard.get_value("ally_blackboards")[_actor.get_instance_id()].set_value("charge_target", monster_pos)
	return BTStatus.RUNNING
