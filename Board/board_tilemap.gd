class_name LangtonTileMap

extends TileMap

signal board_size_changed(size)

enum {WHITE, BLACK, BLUE, RED, YELLOW, GREEN, ORANGE, PURPLE}

func initialize_map(size):
	for i in range(size):
		for j in range(size):
			set_cell(0, Vector2(i, j), 0, Vector2(0,0))
	
	position = Vector2(-(size / 2.0) * tile_set.tile_size.x, -(size / 2.0) * tile_set.tile_size.y)
	
	board_size_changed.emit(size)
	

func swap_tile(coord :Vector2i, new_color : int):
	set_cell(0, coord, 0, Vector2i(new_color, 0))
