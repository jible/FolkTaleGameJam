class_name MeleeAllyController extends Node2D


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
	
	if not _dodge_timer:
		_create_dodge_timer()

	if not _movement_timer:
		_create_movement_timer()

	# Set the actor
	fsm.blackboard.set_value("movement_input", movement_input)
	fsm.blackboard.set_value("character", character)
	fsm.blackboard.set_value("dodge_timer", _dodge_timer)
	fsm.blackboard.set_value("fsm", fsm)
	fsm.blackboard.set_value("dodge_input", false)
	assert(character, "Character not set")
	fsm.actor = character
	
	if active:
		activate()


func _create_dodge_timer() -> void:
	_dodge_timer = Timer.new()
	_dodge_timer.set_wait_time(DODGE_COOLDOWN)
	_dodge_timer.set_one_shot(true)
	add_child(_dodge_timer)


func _create_movement_timer() -> void:
	_movement_timer = Timer.new()
	_movement_timer.set_wait_time(4)
	_movement_timer.set_one_shot(false)
	_movement_timer.timeout.connect(_on_movement_timer_timeout)
	_movement_timer.autostart = true
	add_child(_movement_timer)


func activate() -> void:
	if not active:
		active = true
	if not _dodge_timer:
		_create_dodge_timer()
	if not _movement_timer:
		_create_movement_timer()
	fsm.active = true
	fsm.start()
	_movement_timer.start()


func deactivate() -> void:
	if active:
		active = false
	fsm.active = false
	_movement_timer.stop()


# Placeholder movement AI
func _on_movement_timer_timeout() -> void:
	movement_input = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	fsm.blackboard.set_value("movement_input", movement_input)
	
