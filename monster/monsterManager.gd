extends CharacterBody2D


enum States  { IDLE, PURSUIT, GORE, POUNCE, DEATH, SLASH}

var currentState = States.IDLE
@onready var facePlayer = self.get_script()
@onready var targetAngle = Vector2()
@export var rotateSpeed = 4
@export var pounceAcceleration = 100
@export var pounceMaxSpeed = 500
@export var attackRange = 100
@onready var currentTween = null
# Move towards this point
@onready var targetPoint = Vector2(0 , 0)
@export var acceleration = 20
@export var maxSpeed = 500

func _ready():
	await get_tree().create_timer(3).timeout
	targetPoint = get_global_mouse_position()
	onEnter(currentState)


func _physics_process(delta):
	targetPoint = get_global_mouse_position()
	targetAngle = ( targetPoint - global_position)
	updateStateMachine(delta)
	move_and_slide()

#region STATE MACHINE
func updateStateMachine(delta):
	match currentState:
		States.IDLE:
			idle(delta)
		States.PURSUIT:
			pursuit(delta)
		States.GORE:
			gore(delta)
		States.POUNCE:
			pounce(delta)
		States.DEATH:
			death(delta)
		States.SLASH:
			slash(delta)

func changeState(newState):
	if newState != currentState:
		onExit(currentState)
		currentState = newState
		onEnter(newState)
	
	
	
func onExit(state): # End coroutines and animations for one state
	if currentTween != null:
		currentTween.stop()
		currentTween = null
	$AnimationPlayer.stop()
	match state:
		States.IDLE:
			pass
		States.PURSUIT:
			velocity = Vector2(0,0)
		States.GORE:
			pass
		States.POUNCE:
			pass
		States.SLASH:
			pass
		States.DEATH:
			pass


func onEnter(state): # Start coroutines and animations for new state
	match state:
		States.IDLE:
			pass
		States.PURSUIT:
			pass
		States.GORE:
			#play gore animation
			$AnimationPlayer.play("gore_attack")
			await $AnimationPlayer.animation_finished
			changeState(States.IDLE)
			pass
		States.POUNCE:
			var startingPosition = global_position 
			#jump towards the target
			var doJump = targetPoint.distance_to(global_position)  > attackRange
			if (doJump):
				await jumpToTarget()
				print ("completed pounce")
			pounceAttack()
			if doJump:
				await jumpToStart(startingPosition)
			pass
			changeState(States.IDLE)
		States.SLASH:
			$AnimationPlayer.play("slashing_attack")
			await $AnimationPlayer.animation_finished
			changeState(States.IDLE)
		States.DEATH:
			$AnimationPlayer.play("death")
			await $AnimationPlayer.animation_finished
			## Go to next scene  
			pass
#endregion

#region DEATH STATE
func death(delta):
	return
	
func end():
	# once the monster plays the die animation, do whatever needs to happen here!
	return
#endregion

#region SLASH STATE
func slash(delta):
	return
#endregion

#region IDLE STATE
func idle(delta):
	
	changeState(States.PURSUIT)
	return
#endregion

#region GORE STATE
func gore(delta):
	
	return
	
	
	
#endregion 

#region POUNCE STATE
func pounce(delta):
	return
	
func jumpToTarget():
	
	var jumpEnd = targetPoint - (targetPoint - global_position).normalized() * attackRange 
	var tween = create_tween()
	currentTween = tween
	$AnimationPlayer.play("pounce")
	tween.tween_property(self, "position",jumpEnd, $AnimationPlayer.current_animation_length).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	await $AnimationPlayer.animation_finished
	currentTween = null

	
func pounceAttack():
	#makeHitbox
	$pounceHitbox.monitoring = true
	
	# await play animation
	$pounceHitbox.monitoring = false
	
func jumpToStart(startingPosition):
	var tween = create_tween()
	currentTween = tween
	$AnimationPlayer.play("pounce_return")
	tween.tween_property(self, "position",startingPosition, $AnimationPlayer.current_animation_length).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	await $AnimationPlayer.animation_finished
	currentTween = null

#endregion

#region PURSUIT STATE
func pursuit(delta):
	$AnimationPlayer.play("run")
	moveToward(delta)
	if ( findDistance(position, targetPoint)  < 50):
		changeState(States.GORE)
	# If it get close enough to attack, stop pursuing and attack
	
	return
	
func moveToward(delta):
	
	velocity += targetAngle.normalized() * acceleration *delta * 60
	velocity = velocity.limit_length(maxSpeed)
	
func findDistance(pointA, pointB):
	return pointA.distance_to(pointB)
#endregion
