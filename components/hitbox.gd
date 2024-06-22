@tool
class_name Hitbox extends Area2D


# Signals
signal just_hit(object, hurtbox: Hurtbox)


@export var shape : Shape2D = RectangleShape2D.new()
@onready var collision_shape := CollisionShape2D.new()


func _ready():
	assert(shape, "Hitbox shape not set")
	add_child(collision_shape, false, INTERNAL_MODE_FRONT)

func _process(_delta):
	if Engine.is_editor_hint():
		if collision_shape and shape and collision_shape.shape != shape:
			collision_shape.shape = shape
