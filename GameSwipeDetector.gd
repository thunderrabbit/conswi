extends Area2D

const SwipeShape = preload("res://subscenes/SwipeShape.tscn")

var clicked_this_piece_type = 0				# set when swipe is started
var swipe_mode= false			# if true, then we are swiping
var swipe_array = []			# the pieces in the swipe
var swipe_shape = null			# will animate shape user swiped
var wasted_swipes = 0
var Game						# will point to GameNode
enum SwipeState {IDLE, SWIPE = 5, DRAG}		# how should _input_event respond
var swipe_state = SwipeState.SWIPE
var dragging_piece = null					# when dragging a piece, this will refer to it

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func startLevel():
	self.wasted_swipes = 0	# wasted swipes will count against bonus

# this handles dragging pieces and orphaned swipes
func _on_GameSwipeDetector_input_event( viewport, event, shape_idx ):
	match swipe_state:
		SwipeState.IDLE:
			pass
		SwipeState.SWIPE:
			_on_GSD_swipe_event(event)
		SwipeState.DRAG:
			_on_GSD_drag_event(event)

func _on_GSD_swipe_event(event):
	if event is InputEventMouseButton:
		if event.button_index == 1:
			if !event.pressed:
				piece_unclicked()

func _on_GSD_drag_event(event):
	# allows drag to happen quickly
	dragging_piece.position = get_viewport().get_mouse_position()

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func piece_clicked(position, piece_type):
	if swipe_array.size() == 1:
		# probably a duplicate click
		return
	clicked_this_piece_type = piece_type
	VisibleSwipeOverlay.set_swipe_color(TileDatabase.tiles[piece_type].ITEM_COLOR)
	swipe_state = SwipeState.SWIPE
	swipe_array.append(position)
	Helpers.board[position].highlight()		# tell Piece to appear as if it is swiped

func piece_unclicked():
	# make sure the swipe is long enough to count (per level basis)
	if swipe_array.size() < Game.current_level.min_swipe_len:
		for pos in swipe_array:
			Helpers.board[pos].unhighlight()
	# the swipe is long enough
	else:
		if Helpers.debug_level > 0:
			ShapeShifter.givenSwipe_showArray(swipe_array)
		var swipe_name = ShapeShifter.givenSwipe_lookupName(swipe_array)

		var dimensions = ShapeShifter.getSwipeDimensions(swipe_array)
		# figure out if the swipe is required
		var swipe_was_required = Game.game_hud.level_reqs.swiped_piece(swipe_name)

		swipe_shape = SwipeShape.instance()
		swipe_shape.set_shape(ShapeShifter.getBitmapOfSwipeCoordinates(swipe_array),clicked_this_piece_type)
		swipe_shape.set_position(Helpers.slot_to_pixels(dimensions["topleft"], 1, false))		# change false to true to debug position. 1 is xfactor (larger pushes to right and breaks things)
		add_child(swipe_shape)
		if swipe_was_required:
			swipe_shape.connect("shrunk_shape",self,"shrank_required_shape")
			# after swipe, move shape to correct/required shape location
			swipe_shape.shrink_shape(Game.game_hud.level_reqs.required_swipe_location(swipe_name))
		else:
			swipe_shape.connect("flew_away", self, "inc_wasted_swipe_counter")
			swipe_shape.fly_away_randomly()
			self.wasted_swipes = self.wasted_swipes + 1
		# TODO add animation swipe_shape.animate()
		for pos in swipe_array:
			if Helpers.board[pos] != null:
				Helpers.board[pos].unhighlight()  # restore color so the effect is pretty.  Only needed while the highlight is black
				Helpers.board[pos].remove_yourself()
	swipe_array.clear()
	swipe_state = SwipeState.IDLE

######################################
#
#  Called when user starts dragging a piece.
func piece_being_dragged(piece):
	dragging_piece = piece
	swipe_state = SwipeState.DRAG

# not sure if this should put the piece in the slot or Game.  At this point Game does it though
func piece_done_dragged(slot):
	print("piece done dragged to ", slot)
	swipe_state = SwipeState.IDLE
	dragging_piece = null

func inc_wasted_swipe_counter():
	print("wasted this many swipes: ", self.wasted_swipes)		# should be displayed on screen
	print("Add a coutner for that number on the screen")
	HUD.get_node('WastedSwipeCount').set_value(self.wasted_swipes)

func piece_entered(position, piece_type):
	if swipe_state != SwipeState.SWIPE:
		return
	if clicked_this_piece_type != piece_type:
		return
	# ensure the position is adjacent to the last item in the array
	if not adjacent(swipe_array.back(), position):
		return
	if position == swipe_array[swipe_array.size()-2]:
		# we back tracked
		var old_last = swipe_array.back()
		swipe_array.pop_back()
		Helpers.board[old_last].unhighlight()
	else:
		swipe_array.append(position)
		Helpers.board[position].highlight()		# tell Piece to appear as if it is swiped
	VisibleSwipeOverlay.draw_this_swipe(swipe_array,TileDatabase.tiles[piece_type].ITEM_COLOR)

func adjacent(pos1, pos2):
	# https://www.gamedev.net/forums/topic/516685-best-algorithm-to-find-adjacent-tiles/?tab=comments#comment-4359055
	var xOffsets = [ 0, 1, 0, -1]
	var yOffsets = [-1, 0, 1,  0]

	var i = 0
	var offset_pos2 = Vector2(-99,-99)
	while i < xOffsets.size():
		offset_pos2 = Vector2(pos2.x + xOffsets[i], pos2.y + yOffsets[i])
		if pos1 == offset_pos2:
			return true
		i = i + 1
	return false

func piece_exited(position, piece_type):
	# mouse moved out of a tile
	# but we only care if it moved into a tile
	pass

func shrank_required_shape():
	swipe_shape.queue_free()
	Game.game_hud.level_reqs.clarify_requirements()