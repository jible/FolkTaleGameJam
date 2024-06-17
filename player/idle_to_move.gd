extends FSMTransition


# Executed when the transition is taken.
func _on_transition(_delta: float, _actor: Node, _blackboard: Blackboard) -> void:
	print("Transitioning to moving from idle")	


# Evaluates true, if the transition conditions are met.
func is_valid(_actor: Node, _blackboard: Blackboard) -> bool:
	var movement = _blackboard.get_value("movement_input")
	assert(movement is Vector2)
	if movement.length_squared() > 0.1:
		return true
	return false	
