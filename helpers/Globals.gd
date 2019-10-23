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
#  Globals can be accessed with G.MAX_STARS, and are generally designed to hold constants
#
#####################################################################################

extends Node

const finger_swipe_duration = .3		# how many seconds finger shows how to swipe
const splashscreen_timeout = 2.3		# how many seconds to wait on splash screen
const max_spash_screens    = 6		# there are several splash screens
var   current_screen = 0			# which screen to start

##  http://www.gamefromscratch.com/post/2015/02/23/Godot-Engine-Tutorial-Part-6-Multiple-Scenes-and-Global-Variables.aspx
const GLOBALtop_space = 0		# Might just move the Popup down instead   # EGAD non-zero breaks the Helpers slot_to_pixels calculation
const GLOBALleft_space = 20		# Space on the left  # non-zero messed up calculation, I thought, but now seems okay.  Maybe if both are non-zero it messes it up.
const GLOBALslot_gap_v = 5
const GLOBALslot_gap_h = 5
const SLOT_SIZE = 57

const MAX_STARS = 3				# per level, shown on level select screen; used by high score saver, Savior.gd

# arbitrarily ordered ways to win or lose a level
const LEVEL_WIN 		= 1
const LEVEL_NO_ROOM		= 2
const LEVEL_NO_TIME		= 3
const LEVEL_NO_TILES	= 4

# The order of these types must match icon.png
const TYPE_PIG			= 0
const TYPE_SHEEP		= 1
const TYPE_PANDA		= 2
const TYPE_DOG			= 3
const TYPE_COW			= 4
const TYPE_CAT			= 5
const TYPE_BEAR			= 6
const TYPE_LION			= 7    # Right now, TYPE_LION and following do not exist in icons, but are on world select screen
const TYPE_MONKEY		= 8
const TYPE_PANDA		= 9
const TYPE_RABBIT		= 10
const TYPE_TIGER		= 11

const STAR_DISPLAY_BONUS = 0
const STAR_REDUCE_SWIPES = 1
const STAR_REDUCE_TILES = 2
const STAR_ADD_TIME_REMAIN = 3
const STAR_DISPLAY_STARS = 4
const STAR_REMOVE_PANEL = 5

# Before each level, the required pieces are shown and then shrink as they move up to upper left.
# If the shrink location is 1, they will each take a single square worth of space
# At a shrink factor of 0.2, they fit within one space, but are too small for the player to see
# We probably need a whole better way to place them, but this works for now.
const REQ_SHAPE_SHRINK_FACTOR = 0.4			# required shapes become this big compared to normal
const REQ_SHAPE_SHRINK_LOCATION = 1.5		# required shapes display this many column widths apart
