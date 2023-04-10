class_name AntsManager

extends Node2D


var board : LangtonTileMap
var is_placing_ants = false
var ant_scene = preload("res://Ants/ant.tscn") 
var ants = []
var orientation_of_ant_to_place = 0




func spawn_ant():
	var ant_instance = ant_scene.instantiate() as Ant
	add_child(ant_instance)
	ant_instance.connect("color_change_requested", _on_ant_color_change_requested)
	ant_instance.connect("move_requested", _on_ant_move_requested)
	ants.append(ant_instance)


func place_ant(ant : Ant, map_coord, _orientation = ant.orientation):
	ant.coordinate = map_coord
	ant.global_position = board.to_global(board.map_to_local(map_coord))
	ant.orientation = _orientation


func destroy_ant(ant:Ant):
	ants.erase(ant)
	ant.queue_free()
	if ants.is_empty():
		print("no ants left")


func destroy_all_ants():
	for i in range(0, ants.size()):
		destroy_ant(ants.back())



func activate_ant(ant):
	var old_tile_data = board.get_cell_tile_data(0, ant.coordinate)
	var old_tile_color = old_tile_data.get_custom_data_by_layer_id(0)
	ant.apply_instruction(old_tile_color)


func activate_all_ants():
	for ant in ants:
		activate_ant(ant)

	
func ants_present(coordinate : Vector2i):
	var list_of_ants_present = []
	if board.is_tile_in_map(coordinate):
		for ant in ants:
			if ant.coordinate == coordinate:
				list_of_ants_present.append(ant)
	return list_of_ants_present



func clash_with_wall(ant, _old_coordinate, _requested_coordinate):
	destroy_ant(ant)


#ant placer method
func _input(event: InputEvent) -> void:
	if is_placing_ants:
		if event.is_action_pressed("left click"):
			var coordinate = board.local_to_map(board.to_local(Mouse.mouse_pos)) 
			if board.is_tile_in_map(coordinate):
				spawn_ant()
				place_ant(ants.back(), coordinate, orientation_of_ant_to_place)
		elif event.is_action_pressed("right click"):
			var coordinate = board.local_to_map(board.to_local(Mouse.mouse_pos)) 
			var ants_clicked = ants_present(coordinate)
			if ants_clicked.size() > 0:
				for ant in ants_clicked:
					destroy_ant(ant)



func _on_ant_color_change_requested(coordinate, new_color) -> void:
	board.swap_tile(coordinate, new_color)


func _on_ant_move_requested(ant, _old_coordinate, requested_coordinate) -> void:
	if board.is_tile_in_map(requested_coordinate) :
		place_ant(ant, requested_coordinate)
	else:
		clash_with_wall(ant, _old_coordinate, requested_coordinate)
