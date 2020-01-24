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

extends Node

# Tiles are referenced by constants defined in Globals, and must match the order in items.png
# e.g.  G.TYPE_PANDA = 0, so Panda must be the zeroth item in array `tiles` below
# A better solution might be to define
#  tiles = [G.TYPE_PIG: { "ITEM_NAME": "Pig", "ITEM_COLOR": Color(1, 1, 0.5, 1) }, ... ]
# but that syntax does not work
var tiles = [
    {
        "ITEM_NAME" : "panda",
        "ITEM_COLOR" : Color(1, 1, 1, 1),
    },
    {
        "ITEM_NAME" : "bear",
        "ITEM_COLOR" : Color(1.0, 0, 0.5, 1.0),
    },
    {
        "ITEM_NAME" : "cow",
        "ITEM_COLOR" : Color(1.0, 0, 0.5, 1.0),
    },
    {
        "ITEM_NAME" : "dog",
        "ITEM_COLOR" : Color(0, 0, 1, 1),
    },
    {
        "ITEM_NAME" : "monkey",
        "ITEM_COLOR" : Color(1.0, 0, 0.5, 1.0),
    },
    {
        "ITEM_NAME" : "sheep",
        "ITEM_COLOR" : Color(0, 1.0, 0.5, 1.0),
    },
    {
        "ITEM_NAME" : "pig",
        "ITEM_COLOR" : Color(1, 1.0, 0.5, 1.0),
    },
    {
        "ITEM_NAME" : "cat",
        "ITEM_COLOR" : Color(1.0, 0, 0.5, 1.0),
    },
    {
        "ITEM_NAME" : "lion",
        "ITEM_COLOR" : Color(1.0, 0, 0.5, 1.0),
    },
    {
        "ITEM_NAME" : "rabbit",
        "ITEM_COLOR" : Color(1.0, 0, 0.5, 1.0),
    },
    {
        "ITEM_NAME" : "tiger",
        "ITEM_COLOR" : Color(1.0, 0, 0.5, 1.0),
    },
]

func _ready():
    randomize()

func random_type():
    return randi() % tiles.size()

