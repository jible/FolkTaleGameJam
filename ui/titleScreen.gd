extends Control

var og_pos : Array[Vector2] = [];
var tweens;

# Called when the node enters the scene tree for the first time.
func _ready():
	# create instance of uiTweens class to use for tweens
	tweens = %disappointment.get_script().new();
	# set up children to be offscreen
	for child in get_children():
		og_pos.push_back(child.position);
		child.position = Vector2(child.position.x, child.position.y+150);
		child.modulate = Color (0, 0, 0, 0);
		child.scale = Vector2(child.scale.x*1.3, child.scale.y*1.3);
	# pull up the children nodes
	await get_tree().create_timer(1.0).timeout;
	var ind : int = 0;
	for child in get_children():
		await get_tree().create_timer(0.3).timeout;
		tweens.wah();
		tweens.puppet_in(child, og_pos[ind]);
		ind += 1;
