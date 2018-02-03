extends Node

const ITEM_NAME         = 0
const ITEM_SPRITE       = 3

var tiles = [
	{
		ITEM_NAME : "Pig",
		ITEM_SPRITE : G.TYPE_PIG,
		"ITEM_COLOR" : Color(1, 1.0, 0.5, 1.0),
	},
	{
		ITEM_NAME : "Sheep",
		ITEM_SPRITE : G.TYPE_SHEEP,
		"ITEM_COLOR" : Color(0, 1.0, 0.5, 1.0),
	},
	{
		ITEM_NAME : "Panda",
		ITEM_SPRITE : G.TYPE_PANDA,
		"ITEM_COLOR" : Color(1, 1, 1, 1),
	},
	{
		ITEM_NAME : "Dog",
		ITEM_SPRITE : G.TYPE_DOG,
		"ITEM_COLOR" : Color(0, 0, 1, 1),
	},
	{
		ITEM_NAME : "Cow",
		ITEM_SPRITE : G.TYPE_COW,
		"ITEM_COLOR" : Color(1.0, 0, 0.5, 1.0),
	},
	{
		ITEM_NAME : "Cat",
		ITEM_SPRITE : G.TYPE_CAT,
		"ITEM_COLOR" : Color(1.0, 0, 0.5, 1.0),
	},
	{
		ITEM_NAME : "Bear",
		ITEM_SPRITE : G.TYPE_BEAR,
		"ITEM_COLOR" : Color(1.0, 0, 0.5, 1.0),
	},
]

func _ready():
	randomize()

func random_type():
	return randi() % tiles.size()

