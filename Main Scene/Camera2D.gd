extends Camera2D

func adjust_zoom(board_size):
	if board_size <= 4:
		zoom = Vector2(1.0,1.0)
	elif board_size <= 8:
		zoom = Vector2(1/2.0, 1/2.0)
	elif board_size <= 16:
		zoom = Vector2(1/4.0, 1/4.0)
	elif board_size <= 32:
		zoom = Vector2(1/8.0, 1/8.0)
	else:
		zoom = Vector2(1/16.0, 1/16.0)
	
	Mouse.camera_zoom = 1.0 / zoom.x


func _on_game_board_board_size_changed(size) -> void:
	adjust_zoom(size)
