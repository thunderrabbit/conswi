extends TextureButton

func set_level(level):
	var path_to_num = String("res://images/levelselect/numbers/" + String(level).pad_zeros(2) + ".png")
	$number.set_texture(load(path_to_num))