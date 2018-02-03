extends Node

var width = 7				# Game tiles across
var height = 10				# Game tiles tall
var fill_level = false		# true half fills level with tiles
var gravity_timeout = 1		# seconds, tile moves down
var min_swipe_len = 3		# higher is harder
var max_tiles_avail = 32768	# including tiles used in fill_level = true
var time_limit_in_sec = 180	# number of seconds to finish level
var debug_level = 0			# boolean for now

var queue_len = 3			# queue is upcoming tiles
var tiles = []				# fill this to define tiles

var level_requirements = { "ta3":1 }	# should not be empty so levels do not insta-win
