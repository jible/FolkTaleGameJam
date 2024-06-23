class_name MeleeAlly extends CharacterBody2D


@export var _player_controlled := false :
	get:
		return _player_controlled
	set(value):
		_player_controlled = value
var is_alive := true
@onready var health := $Health
@onready var _melee_ally_controller := $MeleeAllyController as MeleeAllyController
@onready var _player_controller := $PlayerController as PlayerController
@onready var _skeleton := $Skeleton2D as Skeleton2D
@onready var _ji_stack := preload("res://ally/melee_ally_jian_skeleton_modification_stack_2d.tres")
@onready var _jian_stack := preload("res://ally/melee_ally_jian_skeleton_modification_stack_2d.tres")
@onready var _ji := $IKTargets/Ji as Sprite2D
@onready var _jian := $IKTargets/Jian as Sprite2D

func _ready():
	set_player_controlled(_player_controlled)


func set_player_controlled(value: bool) -> void:
	_player_controlled = value
	if _player_controlled:
		_melee_ally_controller.deactivate()
		_player_controller.activate()
		_skeleton.set_modification_stack(_jian_stack)
		_ji.visible = false
		_jian.visible = true
	else:
		_player_controller.deactivate()
		_melee_ally_controller.activate()
		_skeleton.set_modification_stack(_ji_stack)
		_ji.visible = true
		_jian.visible = false

func get_player_controlled() -> bool:
	return _player_controlled
