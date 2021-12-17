#    Draw fricken "lasers"
#
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

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


func _draw():
    for verts in Helpers.slots_across:
        draw_line(Helpers.slot_to_pixels(Vector2(verts,0)), 
                Helpers.slot_to_pixels(Vector2(verts,Helpers.slots_down)), 
                Color(255, 0, 0),
                1)
    for horiz in Helpers.slots_down:
        draw_line(Helpers.slot_to_pixels(Vector2(0,horiz)), 
                Helpers.slot_to_pixels(Vector2(Helpers.slots_across,horiz)), 
                Color(255, 0, 0),
                1)
