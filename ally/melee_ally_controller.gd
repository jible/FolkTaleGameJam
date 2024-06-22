class_name MeleeAllyController extends Node2D


# Constants
const DODGE_COOLDOWN := 1.0

@export var fsm : FiniteStateMachine
@export var bt : BTRoot
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


func _ready():
	assert(fsm, "FSM not set")
	assert(bt, "BT not set")
	
	if not _dodge_timer:
		_create_dodge_timer()

	# Initialize blackboard values
	fsm.blackboard.set_value("movement_input", movement_input)
	fsm.blackboard.set_value("character", character)
	fsm.blackboard.set_value("dodge_timer", _dodge_timer)
	fsm.blackboard.set_value("fsm", fsm)
	fsm.blackboard.set_value("dodge_input", false)
	assert(character, "Character not set")
	fsm.actor = character
	
	bt.blackboard.get_value("ally_positions")[get_instance_id()] = character.position
	bt.blackboard.get_value("ally_blackboards")[get_instance_id()] = fsm.blackboard
	
	if active:
		activate()


func _process(_delta):
	if not active:
		return
	
	bt.blackboard.get_value("ally_positions")[get_instance_id()] = character.position


func _exit_tree():
	if bt:
		var dict = bt.blackboard.get_value("ally_positions") as Dictionary
		dict.erase(get_instance_id())
		dict.erase(get_instance_id())


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
	bt.active = true


func deactivate() -> void:
	if active:
		active = false
	fsm.active = false
	bt.active = false
