extends Control

var tween_lib : Dictionary = {};

## just some general tweening code for all puppets

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


## find tween OR create tween
func get_tween(obj : Object = self) -> Tween:
	# find tween
	if obj in tween_lib:
		return tween_lib[obj]
	# none found, creating tween
	var t = get_tree().create_tween()
	tween_lib[obj] = t
	return t


## puppet into scene 
func puppet_in(
		puppet : Object = self,
		s : Vector2 = Vector2(0.5, 0.5),
		pos : Vector2 = Vector2(0, 0)
	) -> void:
	var spd : float = 1.6
	var tween = get_tween(puppet).set_parallel(true).set_ease(Tween.EASE_OUT)
	tween.tween_property(puppet, "modulate", Color(1, 1, 1, 1), spd*0.5)
	tween.tween_property(puppet, "scale", Vector2(s.x, s.y), spd*0.5)
	tween.tween_property(puppet, "position", Vector2(pos.x, pos.y+10), spd).set_trans(Tween.TRANS_SPRING)
	tween.set_parallel(false)


## puppet out of scene
func puppet_out(
		puppet : Object = self,
		s : Vector2 = Vector2(0.5, 0.5),
		pos : Vector2 = Vector2(1920/2, 1080*1.5)
	) -> void:
	var spd : float = 1.6
	var tween = get_tween(puppet).set_parallel(true)
	tween.tween_property(puppet, "modulate", Color(0, 0, 0, 0), spd * 0.75)
	tween.tween_property(puppet, "scale", Vector2(s.x, s.y), spd)
	tween.tween_property(puppet, "position", Vector2(pos.x, pos.y), spd)
	tween.set_parallel(false)
	puppet_wobble(puppet)


## puppet wobble wobble
func puppet_wobble(
		puppet : Object = self
	) -> void:
	var spd : float = 0.1
	var ang : int = 5
	var tween = get_tween(puppet)
	# terribly written welp
	tween.tween_property(puppet, "rotation_degrees", ang, spd)
	tween.tween_property(puppet, "rotation_degrees", -ang, spd)
	tween.tween_property(puppet, "rotation_degrees", ang/2, spd/2)
	tween.tween_property(puppet, "rotation_degrees", -ang/2, spd/2)
	tween.tween_property(puppet, "rotation_degrees", 0, spd)

