class_name GameInterface extends Control


var playerHearts : Array[Object] = [];
var heartTexture = preload("res://ui/uiAssets/heart.png");
var NIAN_MAX : float = 100; # get max health for monster!
var tweens;


# Called when the node enters the scene tree for the first time.
func _ready():
	## create instance of uiTweens class to use for tweens
	tweens = %disappointment.get_script().new();
	# start
	var og_pos : Vector2 = %nianHealthBar.position;
	%nianHealthBar.position = Vector2(%nianHealthBar.position.x, %nianHealthBar.position.y+150)
	%nianHealthBar.scale *= 1.05;
	%nianHealthBar.modulate = Color(1, 1, 1, 0);
	tweens.puppet_in(%nianHealthBar, og_pos, Vector2(1, 1));
	# get player current health!
	player_health_update(5);
	#await get_tree().create_timer(0.75).timeout;
	#player_health_update(2);
	#await get_tree().create_timer(0.75).timeout;
	#player_health_update(10);
	#nian_health_update(30);
	#await get_tree().create_timer(0.75).timeout;
	#nian_health_update(100);
	#await get_tree().create_timer(0.75).timeout;
	#nian_health_update(10);
	#await get_tree().create_timer(0.75).timeout;


## health things
func player_health_update(health : int) -> void:
	for i in range(health):
		if i >= len(playerHearts): # create one if need be
			var heart = TextureRect.new();
			heart.texture = heartTexture;
			playerHearts.push_back(heart);
			playerHearts[i].position = Vector2(70+(i*90), -140+150);
			playerHearts[i].scale = Vector2(0.25*1.05, 0.25*1.05);
			playerHearts[i].modulate = Color(1, 1, 1, 0);
			%playerHealthBar.add_child(playerHearts[i]);
		await get_tree().create_timer(0.1).timeout;
		tweens.puppet_in(
			playerHearts[i],
			Vector2(70+(i*90), -140),
			Vector2(0.25, 0.25)
		);
	# the rest of the hearts
	for i in range(health, len(playerHearts)):
		await get_tree().create_timer(0.05).timeout;
		tweens.puppet_out(
			playerHearts[i],
			Vector2(70+(i*90), -140),
			Vector2(0.25, 0.25)
		);


func nian_health_update(health : float) -> void:
	var h = (health/NIAN_MAX) * 625;
	var t = %nianHealth.create_tween().set_parallel(true).set_trans(Tween.TRANS_SPRING);
	var spd = 0.75;
	t.tween_property(%nianHealth, "size", Vector2(h, %nianHealth.size.y), spd);
	t.tween_property(%nianHealth, "position", Vector2(-650+(625-h), %nianHealth.position.y), spd);


func toggle_vignette(visible: bool) -> void:
	%vignette.visible = visible
