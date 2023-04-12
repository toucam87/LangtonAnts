extends Control

@onready var tick_timer_count_label = $StatsVBox/TickTimerCount as Label
@onready var number_of_ants_count_label = $StatsVBox/NumberofAntsCount as Label

signal play_pause
signal reset_board
signal painting_tiles(is_pressed : bool)
signal placing_ants(is_pressed : bool)
signal speed_slider(value : float)

func _on_play_pause_button_pressed() -> void:
	play_pause.emit()


func _on_reset_button_pressed() -> void:
	reset_board.emit()


func _on_paint_tiles_button_toggled(button_pressed: bool) -> void:
	painting_tiles.emit(button_pressed)


func _on_place_ants_button_toggled(button_pressed: bool) -> void:
	placing_ants.emit(button_pressed)


func _on_speed_slider_value_changed(value: float) -> void:
	speed_slider.emit(value)


func _on_game_manager_number_of_ants_updated(number_of_ants) -> void:
	number_of_ants_count_label.text = str(number_of_ants)


func _on_game_manager_ticks_updated(ticks) -> void:
	tick_timer_count_label.text = str(ticks)
