class_name Ant

extends Node2D

@onready var sprite = $AntSprite

var coordinate := Vector2i(0,0) #ant position on grid
var orientation := 0 : set = set_orientation 
var instructions = {} #key is integer of color, returns the rotation amount and the new color of the tile

var tile_looked_at = {
	0 : Vector2i(0,-1),
	1 : Vector2i(1,-1),
	2 : Vector2i(1,0),
	3 : Vector2i(1,1),
	4 : Vector2i(0,1),
	5 : Vector2i(-1,1),
	6 : Vector2i(-1,0),
	7 : Vector2i(-1,-1)
}
enum {WHITE, BLACK, BLUE, RED, YELLOW, GREEN, ORANGE, PURPLE}


signal color_change_requested(coordinate : Vector2i, new_color : int)
signal move_requested(source, old_coordinate : Vector2i, requested_coordinate : Vector2i)

func _ready() -> void:
	set_instructions()
	


func set_instructions():
	instructions[WHITE] = [-2, BLACK]
	instructions[BLACK] = [2, WHITE]


func apply_instruction(old_tile_color : int):
	if instructions.has(old_tile_color):
		rotate_ant(instructions[old_tile_color][0])
		color_change_requested.emit(coordinate,instructions[old_tile_color][1])
		var requested_coordinate = coordinate + tile_looked_at[orientation]
		move_requested.emit(self, coordinate, requested_coordinate)


#orientations/directions are increments from 0 to 7, O being forward, 2 right, 4 back, 6 left
func set_orientation(value: int):
	orientation = positive_modulo(value, 8)
	rotation = orientation * PI/4



func rotate_ant(direction : int):
	orientation = orientation + direction


func positive_modulo(a: int, b: int) -> int:
	return ((a % b) + b) % b
