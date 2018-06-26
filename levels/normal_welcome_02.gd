extends "NormalLevel.gd"

func _init():
	max_tiles_avail = 30
	time_limit_in_sec = 30
	level_requirements = { "ta3":1 }
	show_finger = true			# On early levels, only with straight swipes
