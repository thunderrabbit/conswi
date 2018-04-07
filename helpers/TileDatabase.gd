extends Node

# Tiles are referenced by constants defined in Globals.  e.g.  G.TYPE_PIG = 0, so Pig must be the zeroth item in array `tiles` below
# A better solution might be to define
#  tiles = [G.TYPE_PIG: { "ITEM_NAME": "Pig", "ITEM_COLOR": Color(1, 1, 0.5, 1) }, ... ]
# but that syntax does not work
var tiles = [
	{
		"ITEM_NAME" : "Pig",
		"ITEM_COLOR" : Color(1, 1.0, 0.5, 1.0),
	},
	{
		"ITEM_NAME" : "Sheep",
		"ITEM_COLOR" : Color(0, 1.0, 0.5, 1.0),
	},
	{
		"ITEM_NAME" : "Panda",
		"ITEM_COLOR" : Color(1, 1, 1, 1),
	},
	{
		"ITEM_NAME" : "Dog",
		"ITEM_COLOR" : Color(0, 0, 1, 1),
	},
	{
		"ITEM_NAME" : "Cow",
		"ITEM_COLOR" : Color(1.0, 0, 0.5, 1.0),
	},
	{
		"ITEM_NAME" : "Cat",
		"ITEM_COLOR" : Color(1.0, 0, 0.5, 1.0),
	},
	{
		"ITEM_NAME" : "Bear",
		"ITEM_COLOR" : Color(1.0, 0, 0.5, 1.0),
	},
]

func _ready():
	randomize()

func random_type():
	return randi() % tiles.size()

