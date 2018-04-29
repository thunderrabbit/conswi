extends Node

# Tiles are referenced by constants defined in Globals.  e.g.  G.TYPE_PIG = 0, so Pig must be the zeroth item in array `tiles` below
# A better solution might be to define
#  tiles = [G.TYPE_PIG: { "ITEM_NAME": "Pig", "ITEM_COLOR": Color(1, 1, 0.5, 1) }, ... ]
# but that syntax does not work
var tiles = [
	{
		"ITEM_NAME" : "pig",
		"ITEM_COLOR" : Color(1, 1.0, 0.5, 1.0),
	},
	{
		"ITEM_NAME" : "sheep",
		"ITEM_COLOR" : Color(0, 1.0, 0.5, 1.0),
	},
	{
		"ITEM_NAME" : "panda",
		"ITEM_COLOR" : Color(1, 1, 1, 1),
	},
	{
		"ITEM_NAME" : "dog",
		"ITEM_COLOR" : Color(0, 0, 1, 1),
	},
	{
		"ITEM_NAME" : "cow",
		"ITEM_COLOR" : Color(1.0, 0, 0.5, 1.0),
	},
	{
		"ITEM_NAME" : "cat",
		"ITEM_COLOR" : Color(1.0, 0, 0.5, 1.0),
	},
	{
		"ITEM_NAME" : "bear",
		"ITEM_COLOR" : Color(1.0, 0, 0.5, 1.0),
	},
]

func _ready():
	randomize()

func random_type():
	return randi() % tiles.size()

