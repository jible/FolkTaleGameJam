extends FSMTransition


# Executed when the transition is taken.
func _on_transition(_delta: float, _actor: Node, _blackboard: Blackboard) -> void:
	print("Transitioning to idle from moving")	
	var character = _blackboard.get_value("character") as CharacterBody2D
	character.velocity = Vector2.ZERO


# Evaluates true, if the transition conditions are met.
func is_valid(_actor: Node, _blackboard: Blackboard) -> bool:
	var movement = _blackboard.get_value("movement_input")
	var velocity := _blackboard.get_value("character").velocity as Vector2
	assert(movement is Vector2)
	assert(velocity is Vector2)
	if movement.length_squared() <= 0.1 and velocity.length() < 100:
		return true
	return false	
