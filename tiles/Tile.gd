#    Copyright (C) 2018  Rob Nugen
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.

extends KinematicBody2D

signal drag_started(piece)
signal drag_ended
signal clicked(piece)
signal unclicked
signal entered(piece)
signal exited
signal hit_floor(piece)

var tile_type
var sprite_loc = []
var SwipeOptions = preload("res://enums/SwipeOptions.gd")
var swipe_options = SwipeOptions.CANNOT
# http://docs.godotengine.org/en/3.0/tutorials/physics/physics_introduction.html#move-and-slide
var run_speed = 350
var jump_speed = -1000
var gravity = 0
var hit_floor_announced = false		# will keep us from repeatedly signalling hit floor

var velocity = Vector2()

func get_input():
	if self.swipe_options != SwipeOptions.CAN_DRAG:
		return
	velocity.x = 0
	var right = Input.is_action_pressed('ui_right')
	var left = Input.is_action_pressed('ui_left')

	if is_on_floor() and not self.hit_floor_announced:
		# TODO make this signal ONLY turn off shadow
		# TODO #30 make Player.gd tell Game.gd after the tile has been on floor long enough
		emit_signal("hit_floor", self)
		self.hit_floor_announced = true

	if right:
		velocity.x += run_speed
	if left:
		velocity.x -= run_speed

func _physics_process(delta):
	velocity.y += gravity * delta
	get_input()
	velocity = move_and_slide(velocity, Vector2(0, -1))

var SwipeState = preload("res://enums/SwipeState.gd")
var swipe_state = SwipeState.IDLE

const wd = 100.0			# width of each sprite image in items.png
const ht = 100.0			# height of each sprite images in items.png

func _ready():
	self.connect("drag_started", get_node("/root/GameNode2D"), "piece_being_dragged")
	self.connect("drag_started", get_node("/root/GameNode2D/GameSwipeDetector"), "piece_being_dragged")
	self.connect("drag_ended", get_node("/root/GameNode2D"), "piece_done_dragged")
	self.connect("drag_ended", get_node("/root/GameNode2D/GameSwipeDetector"), "piece_done_dragged")
	self.connect("clicked", get_node("/root/GameNode2D/GameSwipeDetector"), "piece_clicked")
	self.connect("unclicked", get_node("/root/GameNode2D/GameSwipeDetector"), "piece_unclicked")
	self.connect("entered", get_node("/root/GameNode2D/GameSwipeDetector"), "piece_entered")
	self.connect("exited", get_node("/root/GameNode2D/GameSwipeDetector"), "piece_exited")

func _init():
	# within the image map, these are the locations of the tiles
						# left, top, width, height
	sprite_loc.push_back(Rect2(0 * wd, 0, wd, ht));		# cat?
	sprite_loc.push_back(Rect2(1 * wd, 0, wd, ht));		# dog?
	sprite_loc.push_back(Rect2(2 * wd, 0, wd, ht));		# dog?
	sprite_loc.push_back(Rect2(3 * wd, 0, wd, ht));		# dog?
	sprite_loc.push_back(Rect2(4 * wd, 0, wd, ht));		# dog?
	sprite_loc.push_back(Rect2(5 * wd, 0, wd, ht));		# dog?
	sprite_loc.push_back(Rect2(6 * wd, 0, wd, ht));		# dog?

func set_tile_type(my_tile_type):
	self.tile_type = my_tile_type   # TODO: figure out Database later	TileDatabase.get_item_sprite(my_type_ordinal)
	$TFace.set_texture(preload("res://images/items.png"))		# res://images/items.png is a spritesheet
	$TFace.set_region(true)									# we want a small part of it
	$TFace.set_region_rect(sprite_loc[self.tile_type])					# this is the part we want
	$TFace.set_scale(Vector2(G.SLOT_SIZE/wd,G.SLOT_SIZE/ht))

# This will be called by GameScene
func start_swipe_effect():
	# This is where to do some fancy vanishing effect per tile
	# in Godot 2 version, the effect was set up when the tile was created
#	effect.start()
	hide()

# only the Player tiles will be set draggable (not the shadows)
func set_draggable(candrag):
	if candrag:
		self.swipe_options = SwipeOptions.CAN_DRAG
		self.gravity = 50		# ensure only ONE tile at a time will fall
	else:
		self.swipe_options = SwipeOptions.CANNOT
		self.gravity = 0		# if it is not draggable, it should not be falling, I think

# this is set by Player
func set_swipeable(canswipe):
	if canswipe:
		self.swipe_options = SwipeOptions.CAN_SWIPE
	else:
		self.swipe_options = SwipeOptions.CANNOT

func is_shadow():
	self.gravity = 0
	self.set_collision_layer_bit(0, false)	# ensure shadow does not block Tile both layer and mask are required
	self.set_collision_mask_bit(0, false)	# ensure shadow does not block Tile both layer and mask are required
	set_modulate(Color(1,1,1, 0.3))

# TODO create images/items_hightlight.png and swap out the image with set_texture
func highlight():
	set_modulate(Color(.1,.1,.1, 1))

# TODO after create images/items_hightlight.png, unswap the image with set_texture
func unhighlight():
	set_modulate(Color(1,1,1,1))

# Called when level ends
func darken():
	set_modulate(Color(1,1,1,0.5))


func _on_Area2D_input_event( viewport, event, shape_idx ):
	print("replace by _on_Tile_input_event")

func _on_Segment_can_drag(event):
	if  event is InputEventScreenTouch or event is InputEventMouseButton:
		if event.pressed:
			swipe_state = SwipeState.DRAG
			# need to tell Game to stop gravity
			emit_signal("drag_started", self)
		else: # not event.pressed:
			#TODO #31 fix drag via physics
			emit_signal("drag_ended", Helpers.pixels_to_slot(position))
			# need to tell Game to start gravity
			swipe_state = SwipeState.IDLE

func _on_Segment_can_swipe(event):
	print("swipe seg clicked or unclicked")
	if swipe_options != SwipeOptions.CAN_SWIPE:
		print("but not swipable (wtf how did we get past gateway func)")
		return
	if event is InputEventScreenTouch or event is InputEventMouseButton:
		if event.pressed:
			print("swipe seg clicked")
			emit_signal("clicked", Helpers.pixels_to_slot(get_position()), self.tile_type)
		else: # not event.pressed:
			print("swipe seg unclicked")
			emit_signal("unclicked")


func _on_Segment_mouse_entered():
	print("replace by TILE segment entered")

func _on_Segment_mouse_exited():
	print("replace by TILE segment exited")


func _on_Tile_input_event( viewport, event, shape_idx ):
	match swipe_options:
		SwipeOptions.CANNOT:
			return
		SwipeOptions.CAN_DRAG:
			_on_Segment_can_drag(event)
		SwipeOptions.CAN_SWIPE:
			_on_Segment_can_swipe(event)


func _on_Tile_mouse_entered():
	print("tile entered")
	if swipe_options != SwipeOptions.CAN_SWIPE:
		print("but not swipeable")
		return
	emit_signal("entered", Helpers.pixels_to_slot(get_position()), self.tile_type)



func _on_Tile_mouse_exited():
	print("tile exited")
	if swipe_options != SwipeOptions.CAN_SWIPE:
		print("but not swipeable")
		return
	emit_signal("exited", Helpers.pixels_to_slot(get_position()), self.tile_type)

