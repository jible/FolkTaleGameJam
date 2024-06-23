class_name MeleeAlly extends CharacterBody2D


signal died


@export var _player_controlled := false :
	get:
		return _player_controlled
	set(value):
		_player_controlled = value
var is_alive := true
@onready var health := $Health
@onready var _melee_ally_controller := $MeleeAllyController as MeleeAllyController
@onready var _player_controller := $PlayerController as PlayerController
@onready var _ji := $IKTargets/Ji as Sprite2D
@onready var _jian := $IKTargets/Jian as Sprite2D

func _ready():
	set_player_controlled(_player_controlled)
	health.died.connect(func(): 
		if _player_controlled:
			_player_controller.deactivate()
		else:
			_melee_ally_controller.deactivate()
		is_alive = false
		create_tween().tween_interval(5).tween_callback(uiTweens.puppet_out.bind(self))
		died.emit()
	)


func set_player_controlled(value: bool) -> void:
	_player_controlled = value
	if _player_controlled:
		_melee_ally_controller.deactivate()
		_player_controller.activate()
		_ji.visible = false
		_jian.visible = true
	else:
		_player_controller.deactivate()
		_melee_ally_controller.activate()
		_ji.visible = true
		_jian.visible = false

func get_player_controlled() -> bool:
	return _player_controlled
