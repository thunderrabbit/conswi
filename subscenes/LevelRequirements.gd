extends Node2D

const SwipeShape = preload("res://SubScenes/FingerSwipeShape.tscn")

signal levelwon
signal requirements_shown

var requirements = {}				# actual dictionary of requirements may not need to keep
var array_of_required_names = []	# so we can loop through (need to keep so we can keep track of which one to display next)
var location_of_required_shape = {}	# so we know where to display shape
var required_shapes_hud = {}		# so we can update the shapes as swipes happen
var currently_showing_shape = null	# so we can come back and know what shape to shrink
var currently_showing_name = null	# so we can look up where to show it
var num_tiles_required = 0			# so LevelEndedStars knows how big bonus should be
var show_finger = false				# usually do not show swiping finger (just on first couple levels)

func set_game_scene(gameScene):
	connect("levelwon", gameScene, "_on_LevelWon")
	connect("requirements_shown", gameScene, "continue_start_level")

func show_finger_ka(show_finger):
	self.show_finger = show_finger

# first, just get an array of names that we can slowly loop through
# and display each required shape
func level_requires(level_requirements):
	reset_everything()
	requirements = level_requirements
	for reqd_name in requirements:
		var num_required = location_of_required_shape.size()	# will determine where shape should be shown
		array_of_required_names.append(reqd_name)
		location_of_required_shape[reqd_name] = Helpers.slot_to_pixels(Vector2(num_required,1))
	# now that we know what we require, start showing them one by one
	display_next_requirement()

# Used by GameScene to know where swipe shrink animation should end
func required_swipe_location(swipe_name):
	return location_of_required_shape[swipe_name]

func reset_everything():
	remove_old_requirements()
	self.num_tiles_required = 0
	requirements = {}
	array_of_required_names = []
	location_of_required_shape = {}
	required_shapes_hud = {}

func remove_old_requirements():
	for required in required_shapes_hud:
		required_shapes_hud[required].queue_free()				# remove piece from screen

# will start the next requirement to display itself and wait for callback
func display_next_requirement():
	# if no requirements, call back to GameScene to start playing
	if array_of_required_names.size() == 0:
		print("did not find any more requirements")
		print("Total tiles required = ", self.num_tiles_required)
		emit_signal("requirements_shown")
	else:
		# get first requirement in array
		currently_showing_name = array_of_required_names.front()
		# wipe it from array so we don't show it again
		array_of_required_names.pop_front()
		# look up how many are required
		var reqd_qty = requirements[currently_showing_name]

		currently_showing_shape = SwipeShape.instance()
		currently_showing_shape.show_finger = self.show_finger

		required_shapes_hud[currently_showing_name] = currently_showing_shape
		# after shape has been displayed (and number counted down) we will shrink the shape
		currently_showing_shape.connect("displayed_shape",self,"shape_has_been_displayed")
		var count_tiles_this_shape = currently_showing_shape.set_shape(ShapeShifter.getBitmapOfSwipeName(currently_showing_name),G.TYPE_DOG)
		var swipe_dimensions = currently_showing_shape.dimensions
		self.num_tiles_required = self.num_tiles_required + count_tiles_this_shape * reqd_qty
		currently_showing_shape.set_position(Helpers.offset_bottom_center_slot_in_pixels(swipe_dimensions))
		add_child(currently_showing_shape)
		currently_showing_shape.display_quantity(reqd_qty)

func shape_has_been_displayed():
	# once shape has been shrunk, go to above function to display next shape
	currently_showing_shape.connect("shrunk_shape",self,"display_next_requirement")
	currently_showing_shape.shrink_shape(location_of_required_shape[currently_showing_name])

func swiped_piece(piece_name):
	var num_required = 0
	if requirements.has(piece_name):
		num_required = requirements[piece_name]
	print("%d %s required" %[num_required, piece_name])
	if num_required > 0:
		requirements[piece_name] = num_required - 1
	return (num_required > 0)		# return true if piece was required

# See if we won
func clarify_requirements():
	for name in requirements:
		var required = required_shapes_hud[name]
		required.spinner.set_value(requirements[name])
		if requirements[name] == 0:
			requirements.erase(name)	# eventually make requirements empty (so we can win)
			required_shapes_hud.erase(name)		# so we won't try to hide Deleted nodes in remove_old_requirements()
			required.hide()				# remove piece from screen
			required.queue_free()
	if requirements.empty():
		emit_signal("levelwon")
