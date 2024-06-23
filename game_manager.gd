class_name GameManager extends Node2D


signal characters_swapped(old_character: MeleeAlly, new_character: MeleeAlly)

var player : MeleeAlly
@onready var outline_material := preload("res://outline.material") as Material
@onready var ally_blackboard := preload("res://ally/ally_blackboard.tres") as Blackboard
@onready var camera := %MainCamera as Camera2D
@onready var menu_scene := preload("res://ui/menuInterface.tscn")
@onready var ally := preload("res://ally/melee_ally.tscn")
@export var game_ui : GameInterface
@export var ally_start_count : int = 20
@export var monster : Node2D
var allies : Array[MeleeAlly]


func _ready():
	_setup_game()
	await get_tree().create_timer(2).timeout
	start_game()


func _process(_delta):
	ally_blackboard.set_value("monster_position", monster.position)
	ally_blackboard.set_value("monster_rotation", sign(monster.scale.x) * 90)
	ally_blackboard.set_value("monster_health", 100)

func enter_character_swap() -> void:
	var selected_character : MeleeAlly = null
	var swappable_characters : Array[MeleeAlly]
	game_ui.toggle_vignette(true)
	Engine.time_scale = 0.25
	while true:
		var old_swappable_characters := swappable_characters.duplicate()
		swappable_characters = get_swappable_characters(player.position)
		highlight_swappable_characters(old_swappable_characters, swappable_characters)
		selected_character = _get_character_under_cursor()
		print(selected_character)
		if swappable_characters.is_empty():
			end_game()
		if Input.is_action_just_pressed("attack") and selected_character:
			if not selected_character._melee_ally_controller in swappable_characters:
				continue
			var old_character = player
			var success = await swap_character(old_character, selected_character)
			if success:
				exit_character_swap()
				break
		await get_tree().process_frame


func exit_character_swap() -> void:
	Engine.time_scale = 1
	game_ui.toggle_vignette(false)


func swap_character(old_character : MeleeAlly, new_character : MeleeAlly):
	var camera_tween := camera.create_tween()
	camera_tween.tween_property(camera, "position", new_character.position, 0.5).\
			set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	await camera_tween.finished
	if not new_character.is_alive:
		return false
	player = new_character
	player.died.connect(_on_player_died)
	player.set_player_controlled(true)
	return true


func get_swappable_characters(position: Vector2) -> Array[MeleeAlly]:
	for i in range(allies.size()):
		if not allies[i] or not allies[i].is_alive:
			allies.pop_at(i)
	
	allies.sort_custom(func(a, b): 
		return a.distance_to(position) < b.distance_to(position)
	)

	return allies.slice(0, 3)


func highlight_swappable_characters(old_swappable_characters: Array[MeleeAlly],\
		swappable_characters: Array[MeleeAlly]) -> void:
	for character in old_swappable_characters:
		if not character in swappable_characters:
			character.get_node("Polygons").material = null

	for character in swappable_characters:
		var visuals = character.get_node("Polygons")
		if visuals.material != outline_material:
			visuals.material = outline_material


func end_game() -> void:
	await get_tree().create_timer(3).timeout
	get_tree().change_scene_to_packed(menu_scene)


func _setup_game() -> void:
	await _spawn_allies()
	player = allies.pick_random()
	player.set_player_controlled(true)


func start_game() -> void:
	get_tree().paused = false
	


func _get_character_under_cursor() -> MeleeAlly:
	var from = get_viewport().get_camera_2d().get_global_transform().origin
	var to = get_global_mouse_position()
	var space_state = get_world_2d().direct_space_state
	var params = PhysicsRayQueryParameters2D.create(from, to)
	params.collide_with_areas = false
	params.collide_with_bodies = true
	var result := space_state.intersect_ray(params)
	if result.is_empty():
		return null
	return result["collider"]


func _spawn_allies() -> void:
	var screen := get_viewport_rect().size / 2
	for i in range(ally_start_count):
		var character := ally.instantiate() as MeleeAlly
		character.position = Vector2.from_angle(randi_range(0, 360)) * randi_range(300, 500)
		# character.position -= screen
		allies.append(character)
		add_child(character)


func _on_player_died():
	enter_character_swap()
