extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		var tween = get_tree().create_tween()
		tween.tween_property(child, "scale", Vector2(1, 1), 1.0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
