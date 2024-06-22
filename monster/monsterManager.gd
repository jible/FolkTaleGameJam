extends CharacterBody2D


enum States  { IDLE, PURSUIT, ATTACK1, ATTACK2}

var currentState = States.IDLE
@onready var facePlayer = self.get_script()
@export var rotateSpeed = 4
# @export var dashAcceleration = 100
# @export var dashSpeed = 500

# Move towards this point
@onready var targetPoint = Vector2(0 , 0)
@export var acceleration = 20
@onready var speed = 0
@export var maxSpeed = 500

func _physics_process(delta):
	targetPoint = get_global_mouse_position()
	updateStateMachine(delta)
	move_and_slide()

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
			speed = 0
			velocity = Vector2(0,0)
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
	
	changeState(States.PURSUIT)
	return

func pursuit(delta):
	handleRotation(delta)
	moveForward(delta)
	if ( findDistance(position, targetPoint)  < 50):
		changeState(States.ATTACK1)
	# If it get close enough to attack, stop pursuing and attack
	
	return

func attack1(delta):
	return

func attack2(delta):
	return



# --------------------------------------------------------------------------------------------------
# This code is for making the monster pursue the player/ a point

func handleRotation(delta): # This script makes the monster face the targethttps:
	# //www.youtube.com/watch?v=tX9yzjigV1k&ab_channel=MasterAlbert
	# The monster should look in this direction, in order to face its target
	var targetAngle = ( targetPoint - $Sprite2D.global_position)
	var dirOffset = -$Sprite2D.transform.y.angle_to(targetAngle)
	if (abs(dirOffset) < delta *rotateSpeed):
		return
	$Sprite2D.rotate(sign(dirOffset)* min(delta *rotateSpeed, abs(dirOffset)))

func moveForward(delta):
	speed += acceleration
	if speed >maxSpeed:
		speed = maxSpeed
	velocity = Vector2(0, -1).rotated($Sprite2D.rotation) * speed


func findDistance(pointA, pointB):
	return pointA.distance_to(pointB)
