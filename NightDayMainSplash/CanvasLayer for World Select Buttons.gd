extends CanvasLayer

var cow_texture = preload("res://images/Folder_4/cow world@3x.png")
var dog_texture = preload("res://images/Folder_4/dog world@3x.png")
var lion_texture = preload("res://images/Folder_4/lion world@3x.png")
var monkey_texture = preload("res://images/Folder_4/monkey world@3x.png")
var panda_texture = preload("res://images/Folder_4/panda_world@3x.png")
var rabbit_texture = preload("res://images/Folder_4/rabbit world@3x.png")
var tiger_texture = preload("res://images/Folder_4/tiger world@3x.png")
var world_textures = [cow_texture
					,dog_texture
					,lion_texture
					,monkey_texture
					,panda_texture
					,rabbit_texture
					,tiger_texture
					]

func _ready():
	add_world_buttons()

func add_world_buttons():
	var button_width = get_button_width()
	for texture in world_textures:
		var new_butt = TextureButton.new()
#		new_butt.anchor_left = 0.5
#		new_butt.anchor_right = 0.5
		new_butt.anchor_top = 0.5
#		new_butt.anchor_bottom = 0.5
		new_butt.set_normal_texture(texture)
		var texture_size = texture.get_size()
		new_butt.set_scale(Vector2(button_width/texture_size.x,button_width/texture_size.y))
#		new_butt.margin_left = -button_width / 2
#		new_butt.margin_right = -button_width / 2    # not needed?
		new_butt.margin_top = -button_width / 2
#		new_butt.margin_bottom = -button_width / 2    # not needed?

		new_butt.connect("pressed", get_parent(), "world_button_clicked", [new_butt.get_normal_texture()])
		add_child(new_butt)

func get_button_width():
	return OS.get_window_size().x * 0.9


#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
