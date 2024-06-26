class_name uiTweens extends Control


## just some general tweening code for all puppets


## puppet into scene 
static func puppet_in(
		puppet : Node,
		pos : Vector2 = Vector2(0, 0),
		s : Vector2 = Vector2(0.5, 0.5),
	) -> void:
	var spd : float = 0.5;
	var tween = puppet.create_tween().set_parallel(true).set_ease(Tween.EASE_OUT);
	tween.tween_property(puppet, "modulate", Color(1, 1, 1, 1), spd*0.5);
	tween.tween_property(puppet, "scale", Vector2(s.x, s.y), spd*0.5);
	tween.tween_property(puppet, "position", Vector2(pos.x, pos.y+10), spd).set_trans(Tween.TRANS_SPRING);
	tween.set_parallel(false);


## puppet out of scene
static func puppet_out(
		puppet : Node,
		pos : Vector2 = Vector2(1920/2, 1080*1.5),
		s : Vector2 = Vector2(0.5, 0.5),
	) -> void:
	var tween = puppet.create_tween();
	var spd : float = 0.1;
	var ang : int = 5;
	## terribly written wobble
	#tween.tween_property(puppet, "rotation_degrees", ang, spd);
	#tween.tween_property(puppet, "rotation_degrees", -ang, spd);
	#tween.tween_property(puppet, "rotation_degrees", ang/2, spd/2);
	#tween.tween_property(puppet, "rotation_degrees", -ang/2, spd/2);
	#tween.tween_property(puppet, "rotation_degrees", 0, spd);
	spd = 0.3;
	tween.set_parallel(true);
	tween.tween_property(puppet, "modulate", Color(1, 1, 1, 0), spd*0.75);
	tween.tween_property(puppet, "scale", Vector2(s.x*1.05, s.y*1.05), spd);
	tween.tween_property(puppet, "position", Vector2(pos.x, pos.y+150), spd*2);
	tween.set_parallel(false);

