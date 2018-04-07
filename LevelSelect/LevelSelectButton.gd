extends TextureButton

func set_level(level):
	var path_to_num = String("res://images/levelselect/numbers/" + String(level).pad_zeros(2) + ".png")
	$number.set_texture(load(path_to_num))

func scale_to(scale):
	$background.set_scale(scale)
	$number.set_scale(scale)
	$plate.set_scale(scale)
	$icon1.set_scale(scale)
	$icon2.set_scale(scale)
	$icon3.set_scale(scale)
