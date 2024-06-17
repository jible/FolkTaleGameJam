class_name PlayerController extends Node


# Signals
signal dodge_refreshed

# Constants
var DODGE_COOLDOWN := 1.0

@onready var fsm : FiniteStateMachine = $FiniteStateMachine
@export var character : Node2D
@export var active := false :
	get:
		return active
	set(value):
		if value:
			activate()
		else:
			deactivate()

var _dodgeTimer : Timer
var movement_input := Vector2.ZERO


func _ready():
	_dodgeTimer = Timer.new()
	_dodgeTimer.set_wait_time(DODGE_COOLDOWN)
	_dodgeTimer.set_one_shot(true)
	_dodgeTimer.timeout.connect(_on_dodge_timer_timeout)
	add_child(_dodgeTimer)
	
	# Set the actor
	fsm.blackboard.set_value("movement_input", movement_input)
	fsm.blackboard.set_value("character", character)
	fsm.blackboard.set_value("dodge_timer", _dodgeTimer)
	fsm.blackboard.set_value("fsm", fsm)
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


func activate() -> void:
	active = true
	fsm.active = true
	fsm.start()


func deactivate() -> void:
	active = false
	fsm.active = false
	fsm.stop()


func _on_dodge_timer_timeout():
	dodge_refreshed.emit()
	print("Dodge refreshed")
