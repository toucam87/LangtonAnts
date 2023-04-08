extends Node2D

@export var board_size = 16 #works best with powers of 2

@onready var board = $BoardTilemap as LangtonTileMap
@onready var tick_timer = $TickTimer

var ant_scene = preload("res://Ants/ant.tscn") 
var ants = []
var is_placing_ants = false
var orientation_of_ant_to_place = 0
var iterations_per_tick = 1


signal board_size_changed(size)


func _ready() -> void:
	initialize_board()


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
	print(ants)


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


func initialize_board():
	board.initialize_map(board_size)
	tick_timer.paused = true
	spawn_ant()
	place_ant(ants[0], Vector2i((board_size - 1)/2, (board_size - 1)/2))



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
			




func _on_board_tilemap_board_size_changed(size) -> void:
	board_size_changed.emit(size)
	


func _on_ant_color_change_requested(coordinate, new_color) -> void:
	board.swap_tile(coordinate, new_color)


func _on_ant_move_requested(ant, _old_coordinate, requested_coordinate) -> void:
	if board.is_tile_in_map(requested_coordinate) :
		place_ant(ant, requested_coordinate)
	else:
		clash_with_wall(ant, _old_coordinate, requested_coordinate)
	

func _on_tick_timer_timeout() -> void:
	for i in range(iterations_per_tick):
		activate_all_ants()


func _on_speed_slider_value_changed(value: float) -> void:
	if value == 1:
		tick_timer.wait_time = 1 / 4.0
		iterations_per_tick = 1
	elif value == 2:
		tick_timer.wait_time = 1 / 10.0
		iterations_per_tick = 1
	elif value >= 3:
		tick_timer.wait_time = 1 / 60.0
		iterations_per_tick = 2 ** (value - 3)


func _on_play_pause_button_pressed() -> void:
	tick_timer.paused = not tick_timer.paused


func _on_reset_button_pressed() -> void:
	destroy_all_ants()
	initialize_board()


func _on_paint_tiles_button_toggled(button_pressed: bool) -> void:
	if button_pressed:
		board.is_painting_tiles = true
	else:
		board.is_painting_tiles = false


func _on_place_ants_button_toggled(button_pressed: bool) -> void:
	if button_pressed:
		is_placing_ants = true
	else:
		is_placing_ants = false
