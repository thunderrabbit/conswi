extends Area2D

var game_scene

func set_game_scene(my_game_scene):
	game_scene = my_game_scene

# TODO: add mouse MOVEMENT detection and allow swipe to quickly move player left-right-down
# http://docs.godotengine.org/en/stable/learning/features/inputs/mouse_and_input_coordinates.html
# Start with swipe down as it will be identical to "drop_down" action in _input()
func _on_Area2D_input_event( viewport, event, shape_idx ):
	if event.type == InputEvent.MOUSE_BUTTON \
	and event.button_index == BUTTON_LEFT \
	and event.pressed:
		if event.pos.x < self.get_pos().x:
			print("pad left")
			game_scene.input_x_direction = -1
		else:
			print("right")
			game_scene.input_x_direction = 1
	else:
		game_scene.stop_moving()

func _input(event):
	var move_left = event.is_action_pressed("move_left")
	var move_right = event.is_action_pressed("move_right")
	var move_down = event.is_action_pressed("move_down")
	var drop_down = event.is_action_pressed("drop_down")
	var stop_moving = not (Input.is_action_pressed("move_right") or 
						   Input.is_action_pressed("move_left") or
						   Input.is_action_pressed("move_down") or
						   Input.is_action_pressed("drop_down")
						  )

	if move_left:
		print("key move left")
		game_scene.input_x_direction = -1
	elif move_right:
		print("key move right")
		game_scene.input_x_direction = 1
	elif move_down:
		print("key move down")
		game_scene.input_y_direction = 1
	elif drop_down:
		# dropdown puts player into freefall, which he can guide with left-right keys.
		print("key drop down activated")
		game_scene.drop_mode = true
	elif stop_moving:
#		print("stop moving")
		game_scene.stop_moving()
