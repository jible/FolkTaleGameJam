class_name AttackState extends FSMState


@onready var hitbox := $Hitbox as Hitbox
var _attack_cooldown_timer : Timer
var _anim_player : AnimationPlayer


func _on_enter(_actor: Node, _blackboard: Blackboard) -> void:
	print("Entered Attack State")
	_attack_cooldown_timer = _blackboard.get_value("attack_timer")
	_anim_player = _blackboard.get_value("anim_player")
	var actor = _actor as MeleeAlly
	if actor.get_player_controlled():
		_anim_player.play("sword_attack")
	else:
		_anim_player.play("spear_attack")
	_anim_player.current_animation_changed.connect(func(anim_name : String):
		if anim_name.contains("attack"):
			return
		var fsm := _blackboard.get_value("fsm") as FiniteStateMachine
		fsm.fire_event("attack_to_idle")
		_attack_cooldown_timer.start()
		print("Should be leaving Attack State")
	)
