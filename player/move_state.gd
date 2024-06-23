class_name MoveState extends FSMState


var character : CharacterBody2D
var MAX_MOVE_VELOCITY := 200
var ACCELERATION := 25
var FRICTION := 0.25


# Executes after the state is entered.
func _on_enter(_actor: Node, _blackboard: Blackboard) -> void:
	character = _blackboard.get_value("character") as CharacterBody2D


# Executes every _process call, if the state is active.
func _on_update(_delta: float, _actor: Node, _blackboard: Blackboard) -> void:
	var movement = _blackboard.get_value("movement_input")
	character.velocity += movement * ACCELERATION
	character.velocity = character.velocity.limit_length(MAX_MOVE_VELOCITY)
	if movement.length_squared() < 0.1:
		character.velocity *= 1 - FRICTION
	character.move_and_slide()
	_blackboard.get_value("anim_player").play("walk")

# Executes before the state is exited.
func _on_exit(_actor: Node, _blackboard: Blackboard) -> void:
	pass
