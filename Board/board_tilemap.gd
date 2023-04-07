class_name LangtonTileMap

extends TileMap

signal board_size_changed(size)

enum {WHITE, BLACK, BLUE, RED, YELLOW, GREEN, ORANGE, PURPLE}

var active_color = 1
var default_color = 0
var is_painting_tiles = true
var old_mouse_pos = null

func initialize_map(size):
	for i in range(size):
		for j in range(size):
			set_cell(0, Vector2(i, j), 0, Vector2(0,0))
	
	position = Vector2(-(size / 2.0) * tile_set.tile_size.x, -(size / 2.0) * tile_set.tile_size.y)
	
	board_size_changed.emit(size)
	

func swap_tile(coord :Vector2i, new_color : int):
	set_cell(0, coord, 0, Vector2i(new_color, 0))


func _input(_event: InputEvent) -> void:
	if is_painting_tiles:
		if Mouse.left_click_pressed == true:
			var points_to_paint = Mouse.lerped_mouse_positions
			points_to_paint.append(Mouse.mouse_pos)
			for point in points_to_paint:
				var map_point = local_to_map(to_local(point))
				if get_cell_source_id(0, map_point) != -1:
					swap_tile(map_point, active_color)
		elif Mouse.right_click_pressed == true:
			var points_to_paint = Mouse.lerped_mouse_positions
			points_to_paint.append(Mouse.mouse_pos)
			for point in points_to_paint:
				var map_point = local_to_map(to_local(point))
				if get_cell_source_id(0, map_point) != -1:
					swap_tile(map_point, default_color)
