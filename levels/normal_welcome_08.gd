extends "NormalLevel.gd"

func _init():
    max_tiles_avail = 150
    time_limit_in_sec = 390
    min_swipe_len = 4
    level_requirements = { "vertical8":1 }
    queue_len = 5