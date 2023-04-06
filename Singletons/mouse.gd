extends Node


var mouse_pos
var old_mouse_pos
var lerped_mouse_positions : PackedVector2Array
var left_click_pressed = false
var right_click_pressed = false
var camera_zoom = 1.0


func _input(event):
	if event is InputEventMouse:
		mouse_pos = viewport_to_global(event.position)
		if old_mouse_pos is Vector2 and old_mouse_pos != mouse_pos:
			for i in range(1,20):
				var lerped_pos = old_mouse_pos.lerp(mouse_pos, i/20.0)
				lerped_mouse_positions.append(lerped_pos) 
		else:
			lerped_mouse_positions.clear()
	old_mouse_pos = mouse_pos
	
	if event.is_action_pressed("left click"):
		left_click_pressed = true
	if event.is_action_released("left click"):
		left_click_pressed = false
	if event.is_action_pressed("right click"):
		right_click_pressed = true
	if event.is_action_released("right click"):
		right_click_pressed = false
#	
#	print("Left Clicked : ", left_click_pressed)
#	print("Right Clicked : ", right_click_pressed)
#	print("Mouse Motion at: ", mouse_position)

func viewport_to_global(viewport_pos: Vector2):
	var centered_pos = viewport_pos - 1/2.0 * Vector2(ProjectSettings.get_setting("display/window/size/viewport_width"),ProjectSettings.get_setting("display/window/size/viewport_height"))
	return camera_zoom * centered_pos

