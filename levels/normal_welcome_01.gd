extends "NormalLevel.gd"

func _init():
	tiles = [G.TYPE_DOG,
			G.TYPE_DOG,
			G.TYPE_DOG,
			31415]	# without the  last number, the first three are not all used??
	max_tiles_avail = 3
	time_limit_in_sec = 30
