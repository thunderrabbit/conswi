extends "DogLevel.gd"

func _init():
    max_tiles_avail = 100
    time_limit_in_sec = 390
    level_requirements = { "ta3":1,
							"bo3":2,
							"square":2}