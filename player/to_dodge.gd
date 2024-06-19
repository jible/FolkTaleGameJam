extends FSMTransition


# Executed when the transition is taken.
func _on_transition(_delta: float, _actor: Node, _blackboard: Blackboard) -> void:
	print("Dodging")

# Evaluates true, if the transition conditions are met.
func is_valid(_actor: Node, _blackboard: Blackboard) -> bool:
	var inputting_dodge = _blackboard.get_value("dodge_input")
	var dodge_timer = _blackboard.get_value("dodge_timer") as Timer
	var is_active = _blackboard.get_value("fsm").active
	if inputting_dodge and dodge_timer.is_stopped() and is_active: 
		return true
	return false
	
