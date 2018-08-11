#    Copyright (C) 2018  Rob Nugen
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

extends Node2D

# from https://godotengine.org/qa/3829/how-to-draw-a-line-in-2d?show=3837#a3837
var draw_slot_list = []
var swipe_color
var inc_mouse = true

func _ready():
	set_process(true)
	draw_slot_list = []

func set_swipe_color(color):
	swipe_color = color

func draw_this_swipe(swipe, color = Color(1.0, 1.0, 0.5, 1.0), inc_mouse = true):
	self.inc_mouse = inc_mouse
	draw_slot_list = swipe
	self.swipe_color = color

func _process(delta):
	update()

func _draw():
	if draw_slot_list != []:
		var draw_list = []
		for slot in draw_slot_list:
			draw_list.append(Helpers.slot_to_pixels(slot))
		draw_list.append(get_global_mouse_position())	# make the swipe point to mouse (eventually, finger)
		var temp_draw_list = []
		for ob in draw_list:
			temp_draw_list.append(ob)
			if temp_draw_list != []:
				if temp_draw_list != draw_list:
					draw_line(temp_draw_list[temp_draw_list.size()-1], draw_list[temp_draw_list.size()], self.swipe_color, 3)
