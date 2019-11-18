extends Node

var default_texture = preload("res://images/background@2x.png")

func _ready():
	$BackgroundSprite.texture = default_texture

func set_background(bg_num = G.TYPE_DOG):
	var my_type_string = TileDatabase.tiles[bg_num]["ITEM_NAME"]
	# background path example "res://images/world_skins/cow/cow background@3x.png"
	var background = String("res://images/world_skins/" +
							my_type_string + "/" + 
							my_type_string + " background@3x.png")
	$BackgroundSprite.set_texture(load(background))
	$BackgroundSprite.apply_scale(Vector2(0.5,0.5))
