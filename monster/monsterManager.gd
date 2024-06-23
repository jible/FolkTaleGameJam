extends CharacterBody2D

class_name monster

enum States  { IDLE, PURSUIT, GORE, POUNCE, DEATH, SLASH}

var currentState = States.IDLE
@onready var facePlayer = self.get_script()
@onready var targetAngle = Vector2()
@export var pounceAcceleration = 30
@export var pounceMaxSpeed = 150
@export var attackRange = 100
@onready var currentTween = null
# Move towards this point
@onready var targetPoint = Vector2(0 , 0)
@export var acceleration = 20

@export var gameManager = owner
@export var maxSpeed = 100
@onready var previousState = States.GORE
@onready var currentTarget = null

func _ready():
	newTarget()
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
	$AnimationPlayer.stop()
	match state:
		States.IDLE:
			pass
		States.PURSUIT:
			previousState = States.PURSUIT
			velocity = Vector2(0,0)
		States.GORE:
			previousState = States.GORE
			pass
		States.POUNCE:
			previousState = States.POUNCE
			pass
		States.SLASH:
			previousState = States.SLASH
			pass
		States.DEATH:
			pass


func onEnter(state): # Start coroutines and animations for new state
	match state:
		States.IDLE:
			print("im idle")
			pass
		States.PURSUIT:
			print("im in pursuit")
			pass
		States.GORE:
			print("im doing gore?")
			#play gore animation
			
			$AnimationPlayer.play("charge")
			await $AnimationPlayer.animation_finished
			$AnimationPlayer.play("gore_attack")
			await $AnimationPlayer.animation_finished
			changeState(States.IDLE)
			pass
		States.POUNCE:
			print("im pouncing")
			$NodeFlipper.flip(-targetAngle, true, false)
				
			var startingPosition = global_position 
			#jump towards the target
			
			await jumpToTarget()
			print ("completed pounce")
			pounceAttack()
			await jumpToStart(startingPosition)
			print("complete Return pounce")
			changeState(States.IDLE)
			pass
			
		States.SLASH:
			print("im slashing")
			$AnimationPlayer.play("slashing_attack")
			await $AnimationPlayer.animation_finished
			changeState(States.IDLE)
		States.DEATH:
			print("im died")
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
	# Pick the next Target
	# Maybe choose the closest hunter
	# Pick what action to perform
	newTarget()
	chooseAction()
	return
func chooseAction():
	if previousState == States.PURSUIT:
		var potentialStates= [States.GORE, States.SLASH]
		var rand = randi()%2
		changeState(potentialStates[rand])
	else:
		if targetPoint.distance_to(global_position) < 500:
			changeState(States.PURSUIT)
		else:
			if previousState != States.POUNCE:
				changeState(States.POUNCE)
			else:
				changeState(States.PURSUIT)
		
	
#endregion

#region GORE STATE
func gore(delta):
	
	return
	
	
	
#endregion 

#region POUNCE STATE
func pounce(delta):
	return
	
func jumpToTarget():
	
	
	$AnimationPlayer.play("pounce")
	
	await get_tree().create_timer(.7).timeout
	var jumpEnd = targetPoint - (targetPoint - global_position).normalized() * attackRange 
	var tween = create_tween()
	currentTween = tween
	
	
	tween.tween_property(self, "position",jumpEnd,$AnimationPlayer.current_animation_length -.7).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	
	await tween.finished
	#await $AnimationPlayer.animation_finished
	currentTween = null

	
func pounceAttack():
	#makeHitbox
	$pounceHitbox.set_monitoring(true)
	await get_tree().process_frame
	$pounceHitbox.set_monitoring(false)
	return
	
func jumpToStart(startingPosition):
	
	$AnimationPlayer.play("pounce_return")
	
	await get_tree().create_timer(.7).timeout
	var tween = create_tween()
	currentTween = tween
	tween.tween_property(self, "position",startingPosition, $AnimationPlayer.current_animation_length -.7).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
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


func newTarget():
	
	#get the array of enemies
	var player = null
	var enemies = null
	if ( gameManager != null && gameManager.allies!= null && gameManager.allies.length()!=0):
		enemies = gameManager.allies
	
		if randf() >1/2:
			currentTarget = player
		else:
			currentTarget = enemies[(enemies.length()*randf()) ]
			
		# roll a 50/50
		# chases player or
		#chooses random target from all hunters
	return
