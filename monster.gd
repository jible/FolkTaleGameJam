extends CharacterBody2D
## Movement script for the Monster
## If the monster is supposed to move, it turns to face target, then moves towards target


@export var rotateSpeed = 2
@export var acceleration = 30
@export var maxSpeed = 300
@export var move = true
# @export var dashAcceleration = 100
# @export var dashSpeed = 500

# Move towards this point
@onready var targetPoint = Vector2(10, 10)


func _physics_process(delta):
	# only move if it is not performing another action
	if ( move ): 
		# This stores the direction the player faces as a vector. we need as an angle in radians
		var directVector = ( targetPoint - global_position).normalized()
		# The monster should look in this direction, in order to face its target
		var targetDirection = directVector.angle()
		rotateTowards( targetDirection, delta)
		# gonna add movement later!
		# linear_velocity += forward * acceleration * delta
	
	#Always update collision/physics
	move_and_slide()

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
