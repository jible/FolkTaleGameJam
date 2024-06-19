extends CharacterBody2D


enum States  { IDLE, PURSUIT, ATTACK1, ATTACK2}

var currentState = States.IDLE

func _process(delta):
	updateStateMachine(delta)


func updateStateMachine(delta):
	match currentState:
		States.IDLE:
			idle(delta)
		States.PURSUIT:
			pursuit(delta)
		States.ATTACK1:
			attack1(delta)
		States.ATTACK2:
			attack2(delta)

func changeState(newState):
	if newState != currentState:
		onExit(currentState)
		currentState = newState
		onEnter(newState)
	
	
	
func onExit(state): # End coroutines and animations for one state
	match state:
		States.IDLE:
			pass
		States.PURSUIT:
			pass
		States.ATTACK1:
			pass
		States.ATTACK2:
			pass


func onEnter(state): # Start coroutines and animations for new state
	match state:
		States.IDLE:
			pass
		States.PURSUIT:
			pass
		States.ATTACK1:
			pass
		States.ATTACK2:
			pass




func idle(delta):
	return

func pursuit(delta):
	return

func attack1(delta):
	return

func attack2(delta):
	return
