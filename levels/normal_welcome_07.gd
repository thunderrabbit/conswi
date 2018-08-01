extends "DogLevel.gd"

func _init():
    max_tiles_avail = 1900
    gravity_timeout = 10
    time_limit_in_sec = 3390
    fill_level = true
    level_requirements = { "ta3":3,
							"bo3":2,"2L2":1,
							"square":3}