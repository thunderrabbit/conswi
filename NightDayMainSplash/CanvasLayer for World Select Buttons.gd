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
	print(world_buttons.size())
	for i in world_buttons:
		var new_butt = TextureButton.new()
		new_butt.set_normal_texture(i)
		add_child(new_butt)
		print(i.get_size())
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
