extends CharacterBody2D


@export var _player_controlled := false :
	get:
		return _player_controlled
	set(value):
		_player_controlled = value
var is_alive := true
@onready var health := $Health
@onready var _melee_ally_controller := $MeleeAllyController as MeleeAllyController
@onready var _player_controller := $PlayerController as PlayerController


func _ready():
	set_player_controlled(_player_controlled)


func set_player_controlled(value: bool) -> void:
	_player_controlled = value
	if _player_controlled:
		_melee_ally_controller.deactivate()
		_player_controller.activate()
	else:
		_player_controller.deactivate()
		_melee_ally_controller.activate()
