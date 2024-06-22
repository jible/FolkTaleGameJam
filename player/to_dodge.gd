extends FSMTransition


# Executed when the transition is taken.
func _on_transition(_delta: float, _actor: Node, _blackboard: Blackboard) -> void:
	print("Dodging")

# Evaluates true, if the transition conditions are met.
func is_valid(_actor: Node, _blackboard: Blackboard) -> bool:
	var inputting_dodge = Input.is_action_just_pressed("dodge")
	var dodge_timer = _blackboard.get_value("dodge_timer") as Timer
	if inputting_dodge and dodge_timer.is_stopped(): 
		return true
	return false
