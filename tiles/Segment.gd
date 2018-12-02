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

var sprite_loc = []
var draggable = false		# cannot drag unless is Player.mytile and is active in play area
var dragging = false		# if true, means mouse is actively dragging
var mouse_in = false		# if true, mouse can click and start dragging  TODO: solve for touch screens as well

func _init():
	# within the image map, these are the locations of the tiles
						# left, top, width, height
	sprite_loc.push_back(Rect2(0, 0, 100, 100));		# cat?
	sprite_loc.push_back(Rect2(100, 0, 100, 100));		# dog?
	sprite_loc.push_back(Rect2(200, 0, 100, 100));		# dog?
	sprite_loc.push_back(Rect2(300, 0, 100, 100));		# dog?
	sprite_loc.push_back(Rect2(400, 0, 100, 100));		# dog?
	sprite_loc.push_back(Rect2(500, 0, 100, 100));		# dog?
	sprite_loc.push_back(Rect2(600, 0, 100, 100));		# dog?

func set_tile_type(my_tile_type):
	var icon = my_tile_type   # Fack figure out Database later	TileDatabase.get_item_sprite(my_type_ordinal)
#	set_position(get_size()/2)
#	set_scale(Vector2(1,1))
	set_texture(preload("res://images/items.png"))
	set_region(true)
	set_region_rect(sprite_loc[icon])

# This will be called by GameScene
func start_swipe_effect():
	# This is where to do some fancy vanishing effect per tile
	# in Godot 2 version, the effect was set up when the tile was created
#	effect.start()
	hide()

# only the Player tiles will be set draggable (not the shadows)
func set_draggable(candrag):
	self.draggable = candrag

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
			dragging = true
			# need to tell Game to stop gravity
			# emit_signal("clicked", Helpers.pixels_to_slot(get_position()), tile_type)
		else: # not event.pressed:
			#emit_signal("unclicked")
			# need to tell Game to start gravity
			dragging = false
	if dragging:
		position = get_viewport().get_mouse_position()

func _on_Area2D_mouse_entered():
	mouse_in = true


func _on_Area2D_mouse_exited():
	mouse_in = false
