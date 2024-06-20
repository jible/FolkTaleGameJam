@tool
class_name Hurtbox extends Area2D


# Signals
signal just_hit(object, hitbox: Hitbox)


@export var shape : Shape2D = RectangleShape2D.new()
@onready var collision_shape := CollisionShape2D.new()
@export var health : Health

func _ready():
	assert(shape, "Hitbox shape not set")
	add_child(collision_shape)


func _process(_delta):
	if Engine.is_editor_hint():
		if collision_shape and shape and collision_shape.shape != shape:
			collision_shape.shape = shape

func hit(initiator, hitbox: Hitbox, damage: int = 0):
	if health:
		health.take_damage(damage)
	just_hit.emit(initiator, hitbox)
