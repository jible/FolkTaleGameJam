class_name PlayerController extends Node


# Signals
signal dodge_refreshed

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
var movement_input := Vector2.ZERO
var ally_blackboard := preload("res://ally/ally_blackboard.tres") as Blackboard


func _ready():
	assert(fsm, "FSM not set")

	if not _dodge_timer:
		_create_dodge_timer()
	
	# Set the actor
	fsm.blackboard.set_value("movement_input", movement_input)
	fsm.blackboard.set_value("character", character)
	fsm.blackboard.set_value("dodge_timer", _dodge_timer)
	fsm.blackboard.set_value("fsm", fsm)
	fsm.blackboard.set_value("dodge_input", false)
	assert(character, "Character not set")
	fsm.actor = character

	# This is only the case if set in the editor
	if active:
		activate()


func _process(_delta):
	if active:
		movement_input = Vector2.ZERO
		if Input.is_action_pressed("move_right"):
			movement_input.x += 1
		if Input.is_action_pressed("move_left"):
			movement_input.x -= 1
		if Input.is_action_pressed("move_down"):
			movement_input.y += 1
		if Input.is_action_pressed("move_up"):
			movement_input.y -= 1
		movement_input = movement_input.normalized()
		fsm.blackboard.set_value("movement_input", movement_input)
		# Hack to avoid input being lost due to one frame lag on FSM processing
		if Input.is_action_pressed("dodge") or Input.is_action_just_released("dodge"):
			fsm.blackboard.set_value("dodge_input", true)
		else:
			fsm.blackboard.set_value("dodge_input", false)
		ally_blackboard.set_value("player_position", character.position)


func _create_dodge_timer() -> void:
	_dodge_timer = Timer.new()
	_dodge_timer.set_wait_time(DODGE_COOLDOWN)
	_dodge_timer.set_one_shot(true)
	add_child(_dodge_timer)


func activate() -> void:
	if not active:
		active = true
	if not _dodge_timer:
		_create_dodge_timer()
	fsm.active = true
	fsm.start()


func deactivate() -> void:
	if active:
		active = false
	fsm.active = false


func _on_dodge_timer_timeout():
	dodge_refreshed.emit()
	print("Dodge refreshed")
