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

var width = 7				# Game tiles across
var height = 20				# Game tiles tall
var fill_level = false		# true half fills level with tiles
var gravity_timeout = 1		# seconds, tile moves down
var min_swipe_len = 3		# higher is harder
var max_tiles_avail = 32768	# including tiles used in fill_level = true
var time_limit_in_sec = 180	# number of seconds to finish level
var debug_level = 0			# boolean for now
var show_finger = false		# will show finger on early levels (only with straight swipes because I do not know how otherwise)

var queue_len = 3			# queue is upcoming tiles
var tiles = []				# fill this to define tiles

var level_requirements = { "bo3":1 }	# should not be empty so levels do not insta-win
