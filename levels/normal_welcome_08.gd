extends "NormalLevel.gd"

func _init():
    max_tiles_avail = 150
    time_limit_in_sec = 390
    level_requirements = { "vertical8":1 }
    queue_len = 5