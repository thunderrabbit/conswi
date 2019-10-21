#    Copyright (C) 2019  Rob Nugen
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.

extends CanvasLayer

var cow_texture = preload("res://images/Folder_4/cow world@3x.png")
var dog_texture = preload("res://images/Folder_4/dog world@3x.png")
var lion_texture = preload("res://images/Folder_4/lion world@3x.png")
var monkey_texture = preload("res://images/Folder_4/monkey world@3x.png")
var panda_texture = preload("res://images/Folder_4/panda_world@3x.png")
var rabbit_texture = preload("res://images/Folder_4/rabbit world@3x.png")
var tiger_texture = preload("res://images/Folder_4/tiger world@3x.png")
var world_textures = [["cow", cow_texture]
					 ,["dog",dog_texture]
					 ,["lion",lion_texture]
					 ,["monkey",monkey_texture]
					 ,["panda",panda_texture]
					 ,["rabbit",rabbit_texture]
					 ,["tiger",tiger_texture]
					]

func _ready():
	add_world_buttons()

func add_world_buttons():
	var button_width = get_button_width()
	for named_texture in world_textures:
		var texture_name = named_texture[0]
		var texture = named_texture[1]
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

		new_butt.connect("pressed", get_parent(), "world_button_clicked", [texture_name])
		add_child(new_butt)

func get_button_width():
	return OS.get_window_size().x * 0.9


#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
