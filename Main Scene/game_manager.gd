extends Node2D

@export var board_size = 16 #works best with powers of 2

@onready var board = $BoardTilemap as LangtonTileMap
@onready var tick_timer = $TickTimer
@onready var ants_manager = $AntsManager as AntsManager

var iterations_per_tick = 1
var ticks_from_start = 0

signal board_size_changed(size)
signal ticks_updated(ticks)
signal number_of_ants_updated(number_of_ants)


func _ready() -> void:
	ants_manager.board = board
	initialize_board()
	

func initialize_board():
	board.initialize_map(board_size)
	position = Mouse.camera_zoom * Mouse.viewport_center
	tick_timer.paused = true
	ticks_from_start = 0
	ants_manager.spawn_ant()
	ants_manager.place_ant(ants_manager.ants[0], Vector2i((board_size - 1)/2, (board_size - 1)/2))
	ticks_updated.emit(ticks_from_start)
	number_of_ants_updated.emit(ants_manager.ants.size())



func _on_board_tilemap_board_size_changed(size) -> void:
	board_size_changed.emit(size)
	

func _on_tick_timer_timeout() -> void:
	for i in range(iterations_per_tick):
		ants_manager.resolve_ants_on_same_cell()
		ants_manager.activate_all_ants()
		ticks_from_start += 1
		ticks_updated.emit(ticks_from_start)
		number_of_ants_updated.emit(ants_manager.ants.size())


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
	ants_manager.destroy_all_ants()
	initialize_board()


func _on_paint_tiles_button_toggled(button_pressed: bool) -> void:
	if button_pressed:
		board.is_painting_tiles = true
	else:
		board.is_painting_tiles = false


func _on_place_ants_button_toggled(button_pressed: bool) -> void:
	if button_pressed:
		ants_manager.is_placing_ants = true
	else:
		ants_manager.is_placing_ants = false


func _on_ants_manager_player_changed_number_of_ants(current_number) -> void:
	number_of_ants_updated.emit(current_number)


func _on_ants_manager_no_ants_left() -> void:
	tick_timer.paused = true

