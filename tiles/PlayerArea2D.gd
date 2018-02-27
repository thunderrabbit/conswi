extends Area2D

signal clicked
signal unclicked
signal entered
signal exited

var is_a_game_piece = true		# helps detect sprites for group actions
var is_swipable = false			# will prevent clicks from signalling GameScene
var tile_type = null

func _ready():
	self.connect("clicked", get_node("/root/GameScene"), "piece_clicked", [])
	self.connect("unclicked", get_node("/root/GameScene"), "piece_unclicked", [])
	self.connect("entered", get_node("/root/GameScene"), "piece_entered", [])
	self.connect("exited", get_node("/root/GameScene"), "piece_exited", [])

func set_tile_type(type):
	tile_type = type

# called after piece gets nailed to board
func become_swipable():
	print("become swipable")
	# I would think set_process_input(false) should do the same thing
	# but it did not seem to work.
	is_swipable = true

func _on_PlayerArea2D_input_event( viewport, event, shape_idx ):
	if not is_swipable:
		return
	if event is InputEventScreenTouch or event is InputEventMouseButton:
		print(event.pressed)
		print(Helpers.pixels_to_slot(get_position()))

		if event.pressed:
			emit_signal("clicked", Helpers.pixels_to_slot(get_position()), tile_type)
		else: # not event.pressed:
			emit_signal("unclicked")

func _on_PlayerArea2D_mouse_entered():
	print("on _on_PlayerArea2D_mouse_entered event")
	if not is_swipable:
		return
	print(Helpers.pixels_to_slot(get_position()))
	emit_signal("entered", Helpers.pixels_to_slot(get_position()), tile_type)

func _on_PlayerArea2D_mouse_exited():
	print("on _on_PlayerArea2D_mouse_exited event")
	if not is_swipable:
		return
	print(Helpers.pixels_to_slot(get_position()))
	emit_signal("exited", Helpers.pixels_to_slot(get_position()), tile_type)

