class_name GameManager extends Node2D


signal characters_swapped(old_character: MeleeAlly, new_character: MeleeAlly)

var player : MeleeAlly
@onready var outline_material := preload("res://outline.material") as Material

func _on_player_death():
	enter_character_swap()


func enter_character_swap() -> void:
	var selected_character : MeleeAlly = null
	var swappable_characters : Array[MeleeAlly]
	while true:
		var old_swappable_characters := swappable_characters.duplicate()
		swappable_characters = get_swappable_characters(player.position)
		highlight_swappable_characters(old_swappable_characters, swappable_characters)
		selected_character = _get_character_under_cursor()
		print(selected_character)
		
		if Input.is_action_just_pressed("attack") and selected_character:
			if not selected_character._melee_ally_controller in swappable_characters:
				continue
			var old_character = player
			var func_progress = swap_character(player, selected_character)
			while func_progress.is_valid():
				var success = await(func_progress.resume())
				if success == true:
					characters_swapped.emit(old_character, player)
				elif success == false:
					break
				else:
					await get_tree().process_frame
			
		await get_tree().process_frame


func exit_character_swap() -> void:
	pass


func swap_character(old_character : MeleeAlly, new_character : MeleeAlly):
	return false


func get_swappable_characters(position: Vector2) -> Array[MeleeAlly]:
	return []


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
	pass


func start_game() -> void:
	pass


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