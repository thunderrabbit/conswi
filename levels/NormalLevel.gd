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

extends Node

## width and height are not yet able to handle all screen sizes
## e.g. if the screen is square, width and height should be the same
## on a square screen if height is larger, the game board would go off the bottom of the screen
var width = 7				# Game tiles across
var height = 12				# Game tiles tall
var fill_level = false		# true half fills level with tiles
var gravity_timeout = 1		# seconds, tile moves down
var min_swipe_len = 3		# higher is harder
var max_tiles_avail = 32768	# including tiles used in fill_level = true
var time_limit_in_sec = 180	# number of seconds to finish level
var debug_level = 0			# boolean for now
var show_finger = false		# will show finger on early levels (only with straight swipes because I do not know how otherwise)

var queue_len = 3			# queue is upcoming tiles
var tiles = {"dog": 1,
             "cow": 1}		# fill this to define tile percentages via ratios

var star_requirements = { "bo3":1 }	# swipe these shapes to get 3 stars
var required_tiles = { "default":1 }  # use same format as tiles to require more things, but for now the GameHud can only handle one number
var show_unlock_image_after_level_won = null

###########################################
#
#   This file is a base class that can be used for multiple worlds and level numbers
#
#   Let the level know its world and level number
#
func inject_world_and_level(world_num, level):
    var world_name = TileDatabase.tiles[world_num]["ITEM_NAME"]
    print("inside inject_world_and_level world ", world_name, " level ", level)
    _calculate_requirements(world_name, level)

###########################################
#
#   The same level definition will get harder if it is used for higher world / level
#
func _calculate_requirements(world_name, level):
    # 'default' means player must collect N animals from this world, where N is based on level number
    # overwrite in level e.g. required_tiles = { "dog":21 }
    if self.required_tiles.has("default"):   # default is a key and its value does not matter.  It is defined above in this file 
        self.required_tiles[world_name] = 3 * level * level  # Dog world 1 must get 3 dogs
        self.required_tiles.erase("default")    # remove now-meaningless key

func pretty_print_level():
    print("I am a level")
    print("width x height ", width, " x ", height)
    print("requirements to pass level:")
    print(required_tiles)
    print("requirements for 3 stars:")
    print(star_requirements)
    print("End level pretty-print")
