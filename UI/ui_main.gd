extends Control

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
