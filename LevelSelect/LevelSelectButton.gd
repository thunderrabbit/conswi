extends TextureButton

var my_type = G.TYPE_BEAR
var my_type_string = ""

func set_level(level):
	var path_to_num = String("res://images/levelselect/numberedplates/base" + String(level).pad_zeros(2) + "_2x.png")
	$background.set_texture(load(path_to_num))

func set_button_type(type = G.TYPE_DOG):
	self.my_type = type
	self.my_type_string = TileDatabase.tiles[my_type]["ITEM_NAME"]
	var path_to_star = String("res://images/levelselect/icons/" + self.my_type_string + "base_2x.png")
	$starbase.set_texture(load(path_to_star))

func _set_icon_active(icon_num):
	var which_icon = icon_num	# -1 to account for zero-indexed array `icons`
	var path_to_icon = String("res://images/levelselect/icons/" + self.my_type_string + String(which_icon) + "star_" + "2x.png")
	get_node("icon"+String(icon_num)).set_texture(load(path_to_icon))

func set_qty_active(qty = 3):
	var icon = 1
	while icon <= qty:
		_set_icon_active(icon)
		icon = icon + 1

func scale_to(scale):
	$background.set_scale(scale)
	$starbase.set_position($background.position)
	$icon1.set_position($background.position)	# make sure icons line up with background
	$icon2.set_position($background.position)	# make sure icons line up with background
	$icon3.set_position($background.position)	# make sure icons line up with background
	$starbase.set_scale(scale)
	$icon1.set_scale(scale)
	$icon2.set_scale(scale)
	$icon3.set_scale(scale)
