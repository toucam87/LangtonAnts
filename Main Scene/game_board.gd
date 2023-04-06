extends Node2D

@export var board_size = 16 #works best with powers of 2

@onready var board = $BoardTilemap as LangtonTileMap
@onready var ant = $Ant as Ant
@onready var tick_timer = $TickTimer

var iterations_per_tick = 1

signal board_size_changed(size)


func _ready() -> void:
	board.initialize_map(board_size)
	tick_timer.paused = true
	place_ant(Vector2i((board_size - 1)/2, (board_size - 1)/2))



func place_ant(map_coord):
	ant.coordinate = map_coord
	ant.global_position = board.to_global(board.map_to_local(map_coord))



func activate_ant():
	var old_tile_data = board.get_cell_tile_data(0, ant.coordinate)
	var old_tile_color = old_tile_data.get_custom_data_by_layer_id(0)
	ant.apply_instruction(old_tile_color)
	


func _on_board_tilemap_board_size_changed(size) -> void:
	board_size_changed.emit(size)
	

func _on_ant_color_change_requested(coordinate, new_color) -> void:
	board.swap_tile(coordinate, new_color)


func _on_ant_move_requested(_ant, _old_coordinate, requested_coordinate) -> void:
	if board.get_cell_source_id(0, requested_coordinate) != -1 :
		place_ant(requested_coordinate)
	



func _on_tick_timer_timeout() -> void:
	for i in range(iterations_per_tick):
		activate_ant()


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
	board.initialize_map(board_size)
	tick_timer.paused = true
	place_ant(Vector2i((board_size - 1)/2, (board_size - 1)/2))


