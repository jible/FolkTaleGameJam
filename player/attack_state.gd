class_name AttackState extends FSMState


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
		_anim_player.play("melee_ally_spear_attack")
	_anim_player.animation_finished.connect(\
			func(_anim_name):
				var fsm := _blackboard.get_value("fsm") as FiniteStateMachine
				fsm.fire_event("attack_to_idle")
				_attack_cooldown_timer.start()
				print("Should be leaving Attack State")
	, CONNECT_ONE_SHOT)
