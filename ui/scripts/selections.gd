extends Container

var og_pos : Array[Vector2] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	# set up children to be offscreen
	for child in get_children():
		og_pos.push_back(child.position)
		child.position = Vector2(child.position.x, child.position.y+150)
		child.modulate = Color (0, 0, 0, 0)
		child.scale = Vector2(child.scale.x*1.3, child.scale.y*1.3)
	# pull up the children nodes
	await get_tree().create_timer(1.0).timeout
	for child in get_children():
		await get_tree().create_timer(0.5).timeout
