class_name DodgeState extends FSMState


var character : CharacterBody2D
var dodge_time := 0.3
var movement_input : Vector2 
var dodge_direction := Vector2.ZERO
var dodge_distance := 150
var dodge_tween : Tween
var debug_line : Line2D

# Executes after the state is entered.
func _on_enter(_actor: Node, _blackboard: Blackboard) -> void:
	character = _blackboard.get_value("character") as CharacterBody2D
	movement_input = _blackboard.get_value("movement_input") as Vector2
	var anim_player := _blackboard.get_value("anim_player") as AnimationPlayer
	anim_player.play("dodge_roll")
	var speed_scale = anim_player.speed_scale
	anim_player.speed_scale = 1.1 / dodge_time

	assert(character, "Character not found in blackboard")

	dodge_direction = movement_input
	if dodge_direction == Vector2.ZERO:
		dodge_direction = Vector2.DOWN

	var dodge_end_location = character.position + dodge_direction * dodge_distance

	# DEBUG
	# debug_line = Line2D.new()
	# debug_line.width = 2
	# debug_line.add_point(character.position)
	# debug_line.add_point(dodge_end_location)
	# get_tree().root.add_child(debug_line)
	
	dodge_tween = character.create_tween()
	dodge_tween.tween_property(character, "position", dodge_end_location, dodge_time)\
			.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_LINEAR)
	dodge_tween.tween_callback(func(): anim_player.speed_scale = speed_scale)\
			.finished.connect(_on_dodge_finished.bind(_blackboard))


# Executes every _process call, if the state is active.
func _on_update(_delta: float, _actor: Node, _blackboard: Blackboard) -> void:
	# var dodge_speed = _blackboard.get_value("dodge_speed")\
	pass


# Executes before the state is exited.
func _on_exit(_actor: Node, _blackboard: Blackboard) -> void:
	pass


func _on_dodge_finished(_blackboard: Blackboard) -> void:
	_blackboard.get_value("dodge_timer").start()
	var fsm := _blackboard.get_value("fsm") as FiniteStateMachine
	if movement_input.length_squared() > 0.1:
		fsm.fire_event("dodge_to_move")
		character.velocity = movement_input * (dodge_distance / dodge_time)
		print("Dodge to move")
	else:
		fsm.fire_event("dodge_to_idle")	
		print("Dodge to idle")
	
	# DEBUG
	if debug_line:
		debug_line.queue_free()
