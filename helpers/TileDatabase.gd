#    Copyright (C) 2018  Rob Nugen
#
#    TileDatabase knows about each type of tile (name and color)
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

var idsOfNames = {}		# will be filled in automatically based on TileDatbase.tiles

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
    create_name_to_id()
    randomize()

func random_type():
    # returns values from 0 to tiles.size() - 1
    return randi() % 7 # tiles.size()   items.png has only 7 tiles so we cannot go to tiger yet

func create_name_to_id():
    # fill in idsOfNames so we can look up the name of a swipe given its coordinates
    for i in range(0, tiles.size()):
        # get the Item Name as a string to use as a dictionary key in idsOfNames
        var item_name = tiles[i]["ITEM_NAME"]
        # if it exists, then presumably there is an error in the ShapeDatabase
        # (or an error in belief that different swipes produce different arrays)
        idsOfNames[item_name] = i
    print(idsOfNames)
