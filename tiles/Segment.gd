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

func _init():
	# within the image map, these are the locations of the tiles
						# left, top, width, height
	sprite_loc.push_back(Rect2(35, 23, 65, 65));		# cat?
	sprite_loc.push_back(Rect2(120, 23, 65, 65));		# dog?
	sprite_loc.push_back(Rect2(200, 23, 65, 65));		# etc
	sprite_loc.push_back(Rect2(287, 23, 65, 65));
	sprite_loc.push_back(Rect2(376, 23, 65, 65));
	sprite_loc.push_back(Rect2(459, 23, 65, 65));
	sprite_loc.push_back(Rect2(547, 23, 65, 65));

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
