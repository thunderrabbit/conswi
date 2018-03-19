extends Node

const splashscreen_timeout = 0.2

##  http://www.gamefromscratch.com/post/2015/02/23/Godot-Engine-Tutorial-Part-6-Multiple-Scenes-and-Global-Variables.aspx
const GLOBALtop_space = 0		# Might just move the Popup down instead   # EGAD non-zero fucks up the Helpers slot_to_pixels calculation
const GLOBALleft_space = 20		# Space on the left  # non-zero messed up calculation, I thought, but now seems okay.  Maybe if both are non-zero it messes it up.
const GLOBALslot_gap_v = 5
const GLOBALslot_gap_h = 5
const SLOT_SIZE = 57

const LEVEL_WIN 		= 1
const LEVEL_NO_ROOM		= 2
const LEVEL_NO_TIME		= 3
const LEVEL_NO_TILES	= 4

const TYPE_PIG			= 0
const TYPE_SHEEP		= 1
const TYPE_PANDA		= 2
const TYPE_DOG			= 3
const TYPE_COW			= 4
const TYPE_CAT			= 5
const TYPE_BEAR			= 6
