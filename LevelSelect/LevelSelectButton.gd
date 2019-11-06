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

#####################################################################################
#
#    LevelSelectButton instances are used on the level select screen
#
#    They are designed to show "stars" to indicate how well each level was passed.
#    The stars will be animal faces corresponding to which World the player is in.
#
#    World one is Dog world, so up to three Dog faces will show up on each button.
#
#####################################################################################
extends TextureButton

var my_type = G.TYPE_BEAR
var my_type_string = ""
var num_stars = 0

# must be done before we can set the button type
# because each button type is split into images based on number of stars
func set_num_stars(num):
	num_stars = num

# should be done before we set the type so we know which level to show
func set_level(level):
	# we do not need to remember the level because
	# LevelSelectScene links the button press to the respective level select
	var path_to_num = String("res://images/levelselect/numberedplates/base" + String(level).pad_zeros(2) + "_2x.png")
	$level_number.set_texture(load(path_to_num))

func set_button_type(type = G.TYPE_DOG):
	self.my_type = type
	self.my_type_string = TileDatabase.tiles[my_type]["ITEM_NAME"]
	var path_to_star = String("res://images/levelselect/icons/" + self.my_type_string + "base_2x.png")
	$starbase.set_texture(load(path_to_star))

func _set_icon_active(icon_num):
	var which_icon = icon_num	# -1 to account for zero-indexed array `icons`
	var path_to_icon = String("res://images/levelselect/icons/" + self.my_type_string + String(which_icon) + "star_" + "2x.png")
	get_node("icon"+String(icon_num)).set_texture(load(path_to_icon))

##  I actually don't remember if this is being used to scale the images or just position them.
func scale_to(scale):
	$icon1.set_position($background.position)	# make sure icons line up with background
	$icon2.set_position($background.position)	# make sure icons line up with background
	$icon3.set_position($background.position)	# make sure icons line up with background
	$level_number.set_scale(scale)
	$starbase.set_position($level_number.position)
	$starbase.set_scale(scale)
	$icon1.set_scale(scale)
	$icon2.set_scale(scale)
	$icon3.set_scale(scale)
