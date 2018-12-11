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

extends Sprite

signal drag_started(piece)
signal drag_ended

var tile_type
var sprite_loc = []
var SwipeOptions = preload("res://enums/SwipeOptions.gd")
var swipe_options = SwipeOptions.CANNOT

var SwipeState = preload("res://enums/SwipeState.gd")
var swipe_state = SwipeState.IDLE

const wd = 100.0			# width of each sprite image in items.png
const ht = 100.0			# height of each sprite images in items.png

func _ready():
	self.connect("drag_started", get_node("/root/GameNode2D"), "piece_being_dragged")
	self.connect("drag_started", get_node("/root/GameNode2D/GameSwipeDetector"), "piece_being_dragged")
	self.connect("drag_ended", get_node("/root/GameNode2D"), "piece_done_dragged")
	self.connect("drag_ended", get_node("/root/GameNode2D/GameSwipeDetector"), "piece_done_dragged")

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
	set_texture(preload("res://images/items.png"))		# res://images/items.png is a spritesheet
	set_region(true)									# we want a small part of it
	set_region_rect(sprite_loc[self.tile_type])					# this is the part we want
	set_scale(Vector2(G.SLOT_SIZE/wd,G.SLOT_SIZE/ht))

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
	else:
		self.swipe_options = SwipeOptions.CANNOT

# this is set by Player
func set_swipeable(canswipe):
	if canswipe:
		self.swipe_options = SwipeOptions.CAN_SWIPE
	else:
		self.swipe_options = SwipeOptions.CANNOT

func is_shadow():
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
	if not draggable:
		return

	if  event is InputEventScreenTouch or event is InputEventMouseButton:
		if event.pressed:
			swipe_state = SwipeState.DRAG
			# need to tell Game to stop gravity
			emit_signal("drag_started", self)
		else: # not event.pressed:
			emit_signal("drag_ended", Helpers.pixels_to_slot(position))
			# need to tell Game to start gravity
			swipe_state = SwipeState.IDLE

