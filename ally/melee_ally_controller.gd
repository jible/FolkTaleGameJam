extends Node2D


# Constants
var DODGE_COOLDOWN := 1.0

@export var fsm : FiniteStateMachine
@export var character : CharacterBody2D 
@export var active := false :
	get:
		return active
	set(value):
		if value and not active:
			active = true
			activate()
		elif not value and active:
			active = false
			deactivate()
var _dodge_timer : Timer
var _movement_timer : Timer
var movement_input := Vector2.ZERO


func _ready():
	assert(fsm, "FSM not set")
	
	_dodge_timer = Timer.new()
	_dodge_timer.set_wait_time(DODGE_COOLDOWN)
	_dodge_timer.set_one_shot(true)
	add_child(_dodge_timer)
	_movement_timer = Timer.new()
	_movement_timer.set_wait_time(0.3)
	_movement_timer.set_one_shot(false)
	_movement_timer.timeout.connect(_on_movement_timer_timeout)
	add_child(_movement_timer)

	# Set the actor
	fsm.blackboard.set_value("movement_input", movement_input)
	fsm.blackboard.set_value("character", character)
	fsm.blackboard.set_value("dodge_timer", _dodge_timer)
	fsm.blackboard.set_value("fsm", fsm)
	assert(character, "Character not set")
	fsm.actor = character


func activate() -> void:
	if active:
		return
	else:
		active = true
	fsm.active = true
	fsm.start()
	_movement_timer.start()


func deactivate() -> void:
	if not active:
		return
	else:
		active = false
	fsm.active = false
	fsm.stop()
	_movement_timer.stop()


# Placeholder movement AI
func _on_movement_timer_timeout() -> void:
	movement_input = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
