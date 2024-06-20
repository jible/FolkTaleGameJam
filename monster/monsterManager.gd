extends CharacterBody2D


enum States  { IDLE, PURSUIT, ATTACK1, ATTACK2}

var currentState = States.IDLE
@onready var facePlayer = self.get_script()
@export var rotateSpeed = 30
# @export var dashAcceleration = 100
# @export var dashSpeed = 500

# Move towards this point
@onready var targetPoint = Vector2(0 , 0)
@export var acceleration = 20
@onready var speed = 0
@export var maxSpeed = 200

func _physics_process(delta):
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
	updateRotate(delta)
	moveForward(delta)
	# If it get close enough to attack, stop pursuing and attack
	
	return

func attack1(delta):
	return

func attack2(delta):
	return



# --------------------------------------------------------------------------------------------------
# This code is for making the monster pursue the player/ a point

func updateRotate(delta):
	# only move if it is not performing another action
	# This stores the direction the player faces as a vector. we need as an angle in radians
	var directVector = ( targetPoint - global_position).normalized()
	# The monster should look in this direction, in order to face its target
	var targetDirection = directVector.angle()
	rotateTowards( targetDirection, delta)
	

func rotateTowards( targetDirection, delta): ## this incrementally rotates the player towards the 
	# Get the difference between the current angle and the target angle to find which direction it should turn
	var angleDiff =  targetDirection - rotation
	if ( angleDiff > 2 * PI):
		angleDiff -= 2 * PI
	elif angleDiff < -2 * PI:
		angleDiff += 2 * PI
	var rotationDirection = sign(angleDiff)
	# Rotate in the given direction by direction speed every secon d
	var rotationAmount = rotateSpeed * rotationDirection * delta
	
	# If it gets close, slow down
	if abs(angleDiff) < PI / 4.0:  # Adjust this threshold as needed
		rotateSpeed *= 0.9  # Reduce rotation speed as you approach the target direction
	else:
		rotateSpeed = 2.0  # Reset or maintain default rotateSpeed
	
	rotation+= rotationAmount
	
	# If it gets super close, just stop
	if abs(angleDiff) < 0.01:  
		rotation = targetDirection 
		rotateSpeed = 2.0  



func moveForward(delta):
	speed += acceleration
	if speed >maxSpeed:
		speed = maxSpeed
	velocity = Vector2(0, -1).rotated(rotation) * speed


func findDistance(pointA, pointB):
	var xdiff = pointA.x - pointB.x
	var ydiff = pointA.y - pointB.y
	return ( sqrt(xdiff*xdiff +ydiff *ydiff))
