class_name ChargeState extends FSMState


var character : CharacterBody2D
var MAX_CHARGE_VELOCITY:= 275
var ACCELERATION := 15
var FRICTION := 0.2

# Executes after the state is entered.
func _on_enter(_actor: Node, _blackboard: Blackboard) -> void:
	character = _blackboard.get_value("character") as CharacterBody2D
	if character.velocity != Vector2.ZERO:
		character.velocity /= 4
		# TODO: Implement charge up animation and delay
		# Perhaps a step back then a charge forward


# Executes every _process call, if the state is active.
func _on_update(_delta: float, _actor: Node, _blackboard: Blackboard) -> void:
	#var direction = character.velocity.normalized()
	var movement = _blackboard.get_value("movement_input")
	character.velocity += movement * ACCELERATION
	character.velocity = character.velocity.limit_length(MAX_CHARGE_VELOCITY)
	if movement.length_squared() < 0.1:
		character.velocity *= 1 - FRICTION
	character.move_and_slide()


# Executes before the state is exited.
#func _on_exit(_actor: Node, _blackboard: Blackboard) -> void:
	#var movement = _blackboard.get_value("movement_input")
	#var fsm = _blackboard.get_value("fsm") as FiniteStateMachine
	#if movement.length_squared() < 0.1:
		#character.velocity = Vector2.ZERO
		#fsm.fire_event("charge_to_idle")
	#else:
		#fsm.fire_event("charge_to_move")
