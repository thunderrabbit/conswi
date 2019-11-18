#    Allows sideways scrolling of world buttons on WorldSelect.tscn
#
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

# How wide should each world select button be?
# Not 100% so the next one can be seen (so user knows to swipe)
const button_width_percent_of_screen = 0.70

var cow_texture = preload("res://images/Folder_4/cow world@3x.png")
var dog_texture = preload("res://images/Folder_4/dog world@3x.png")
var lion_texture = preload("res://images/Folder_4/lion world@3x.png")
var monkey_texture = preload("res://images/Folder_4/monkey world@3x.png")
var panda_texture = preload("res://images/Folder_4/panda_world@3x.png")
var rabbit_texture = preload("res://images/Folder_4/rabbit world@3x.png")
var tiger_texture = preload("res://images/Folder_4/tiger world@3x.png")
# The order here is the left-to-right ordering of worlds on the side-swipe thing
var world_textures = [[G.TYPE_DOG,dog_texture]
					 ,[G.TYPE_COW, cow_texture]
					 ,[G.TYPE_LION,lion_texture]
					 ,[G.TYPE_MONKEY,monkey_texture]
					 ,[G.TYPE_PANDA,panda_texture]
					 ,[G.TYPE_RABBIT,rabbit_texture]
					 ,[G.TYPE_TIGER,tiger_texture]
					]
var num_buttons = world_textures.size()

func _ready():
	add_world_buttons()

func add_world_buttons():
	var button_width = get_button_width()
	var button_count = 0
	for named_texture in world_textures:
		var texture_name = named_texture[0]
		var texture = named_texture[1]
		var new_butt = TextureButton.new()
		new_butt.rect_position.x = get_left_anchor(button_count)
		new_butt.anchor_top = 0.5
		new_butt.set_normal_texture(texture)
		var texture_size = texture.get_size()
		new_butt.set_scale(Vector2(button_width/texture_size.x,button_width/texture_size.y))
		new_butt.margin_top = -button_width / 2

		new_butt.connect("pressed", get_parent(), "world_button_clicked", [texture_name])
		add_child(new_butt)
		button_count += 1

func get_button_width():
	return OS.get_window_size().x * button_width_percent_of_screen

func get_left_anchor(count):
	var left_margin = (OS.get_window_size().x - get_button_width()) / 2
	var push_right = get_button_width() * count
	return left_margin + push_right


#signal swipe
var swipe_start = null
#var minimum_drag = 100
var swiping = false			# mouse down to slide buttons

func canvas_follow_mouse(mouse_offset):
	var min_left_movement = -1 * get_button_width() * (num_buttons - 1)
	var min_right_movement = 0
	var new_offset_x = mouse_offset.x
	if new_offset_x < min_left_movement:
		new_offset_x = min_left_movement
	if new_offset_x > min_right_movement:
		new_offset_x = min_right_movement
	set_offset(Vector2(new_offset_x,0))

func _input(event):
	# Mouse in viewport coordinates
	if event is InputEventMouseButton:
		if event.is_pressed():
			# get offset() is a built-in function for realtime
			# (swiped) distance of sliding world select images
			swipe_start = event.position - get_offset()
			swiping = true
		else:
			swiping = false
			swipe_start = null	# prepare for next swipe
	elif event is InputEventMouseMotion:
		if swiping:
			# let world select images follow mouse cursor.
			# not sure how to deal with touch
			canvas_follow_mouse(get_viewport().get_mouse_position() - swipe_start)
