extends CharacterBody2D
## Rotation Script
## When rotation is set to true, updateRotate should play and the 


@export var rotateSpeed = 2
@export var rotate = true
# @export var dashAcceleration = 100
# @export var dashSpeed = 500

# Move towards this point
@onready var targetPoint = Vector2(10, 10)

