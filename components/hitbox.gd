@tool
class_name Hitbox extends Area2D


# Signals
signal just_hit(object, hurtbox: Hurtbox)


@export var shape : Shape2D = RectangleShape2D.new()
@onready var collision_shape := CollisionShape2D.new()


func _ready():
	assert(shape, "Hitbox shape not set")
	add_child(collision_shape, false)
	body_entered.connect(_on_body_entered)
	body_shape_entered.connect(_on_body_entered)
	collision_mask = 0b11
	collision_layer = 0b11

func _process(_delta):
	if Engine.is_editor_hint():
		if collision_shape and shape and collision_shape.shape != shape:
			collision_shape.shape = shape
		if not body_entered.is_connected(_on_body_entered):
			body_entered.connect(_on_body_entered)


func _on_body_entered(body):
	print("COLISSION!!!")
	var hurtbox = body.get_node("Hurtbox")
	if not hurtbox:
		print_debug("No hurtbox found")
		return
	just_hit.emit(body, hurtbox)

