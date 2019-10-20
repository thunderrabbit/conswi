extends CanvasLayer

var cow_world_button = preload("res://images/Folder_4/cow world@3x.png")
var dog_world_button = preload("res://images/Folder_4/dog world@3x.png")
var lion_world_button = preload("res://images/Folder_4/lion world@3x.png")
var monkey_world_button = preload("res://images/Folder_4/monkey world@3x.png")
var panda_world_button = preload("res://images/Folder_4/panda_world@3x.png")
var rabbit_world_button = preload("res://images/Folder_4/rabbit world@3x.png")
var tiger_world_button = preload("res://images/Folder_4/tiger world@3x.png")
var world_buttons = [cow_world_button
					,dog_world_button
					,lion_world_button
					,monkey_world_button
					,panda_world_button
					,rabbit_world_button
					,tiger_world_button
					]

func _ready():
	add_world_buttons()

func add_world_buttons():
	var button_width = get_button_width()
	for i in world_buttons:
		var new_butt = TextureButton.new()
		new_butt.anchor_left = 0.5
		new_butt.anchor_right = 0.5
		new_butt.anchor_top = 0.5
		new_butt.anchor_bottom = 0.5
		new_butt.set_normal_texture(i)
		var texture_size = i.get_size()
		new_butt.margin_left = -button_width / 2
		new_butt.margin_right = -button_width / 2
		new_butt.margin_top = -button_width / 2
		new_butt.margin_bottom = -button_width / 2
		add_child(new_butt)
		print()

func get_button_width():
	return OS.get_window_size().x * 0.9

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
