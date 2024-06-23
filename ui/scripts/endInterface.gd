extends Control


var og_pos : Dictionary = {};


# Called when the node enters the scene tree for the first time.
func _ready():
	## position saving
	for child in %endScreen.get_children():
		og_pos[child] = child.position;
		child.position = Vector2(child.position.x, child.position.y+150)
		child.scale *= 1.05;
		child.modulate = Color(1, 1, 1, 0);
	## button functionality
	%restartButton.connect("pressed", Callable(self, "_swap_scene").bind("game"));
	%menuButton.connect("pressed", Callable(self, "_swap_scene").bind("menu"));
	## start up main screen
	await get_tree().create_timer(1.0).timeout;
	for child in %endScreen.get_children():
		await get_tree().create_timer(0.2).timeout;
		uiTweens.puppet_in(child, og_pos[child])

func _swap_scene(scene : String) -> void:
	# don't question it
	if scene == "game":
		print("sstarting game");
		for child in %endScreen.get_children():
			uiTweens.puppet_out(child, og_pos[child]);
			await get_tree().create_timer(0.2).timeout;
		# update if moved!!
		get_tree().change_scene_to_file("res://ui/gameInterface.tscn");
	elif scene == "menu":
		print("swapping to menu");
		for child in %endScreen.get_children():
			uiTweens.puppet_out(child, og_pos[child]);
			await get_tree().create_timer(0.2).timeout;
		# update if moved!!
		get_tree().change_scene_to_file("res://ui/menuInterface.tscn");

