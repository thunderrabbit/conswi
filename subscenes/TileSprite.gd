extends Sprite

var sprite_loc = []

func _init():
						# left, top, width, height
	sprite_loc.push_back(Rect2(35, 23, 65, 65));
	sprite_loc.push_back(Rect2(120, 23, 65, 65));
	sprite_loc.push_back(Rect2(200, 23, 65, 65));
	sprite_loc.push_back(Rect2(287, 23, 65, 65));
	sprite_loc.push_back(Rect2(376, 23, 65, 65));
	sprite_loc.push_back(Rect2(459, 23, 65, 65));
	sprite_loc.push_back(Rect2(547, 23, 65, 65));

func set_tile_type(my_tile_type):
	var icon = my_tile_type   # Fack figure out Database later	TileDatabase.get_item_sprite(my_type_ordinal)
#	set_pos(get_size()/2)
#	set_scale(Vector2(1,1))
	set_texture(preload("res://images/items.png"))
	set_region(true)
	set_region_rect(sprite_loc[icon])

func is_shadow():
	set_modulate(Color(1,1,1, 0.3))

# TODO create images/items_hightlight.png and swap out the image with set_texture
func highlight():
	set_modulate(Color(.1,.1,.1, 1))

# TODO after create images/items_hightlight.png, unswap the image with set_texture
func unhighlight():
	set_modulate(Color(1,1,1,1))

# Called when level ends
func darken():
	set_modulate(Color(1,1,1,0.5))
