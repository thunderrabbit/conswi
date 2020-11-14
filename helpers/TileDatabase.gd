#    Copyright (C) 2020  Rob Nugen
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

var idsOfNames = {}		# will be filled in automatically based on TileDatabase.tiles

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

# Get the total number of all allowed tiles.
# e.g. {"dog":3,"cat":2,"mouse":1}  will return 6
# So we can choose a number from 1 to 6
# and get a tile randomly by ratios.
# i.e. Choose "dog" half the time in example above.
func ratio_total(tile_ratios):
    var total = 0
    for tilename in tile_ratios:
        total = total + tile_ratios[tilename]
    return total

# returns a named tile type based on a random number between 1 and ratio_total
func which_type(tile_ratios, random_numerator):
    var total = 0
    var return_type = ""
    for tilename in tile_ratios:
        total = total + tile_ratios[tilename]
        if random_numerator <= total:
            return_type = tilename
            break
    # print("random_numerator is ", random_numerator)
    # print("which_type returns ", return_type)
    return return_type
   
func random_type(tile_ratios):
    var denominator = ratio_total(tile_ratios)
    # calculate values from 1 to denominator
    var random_numerator = 1 + (randi() % denominator)
    var type_name = which_type(tile_ratios,random_numerator)
    # return a numeric type based on the levels ratios of types
    return(idsOfNames[type_name])

func create_name_to_id():
    # fill in idsOfNames so we can look up the name of a swipe given its coordinates
    for i in range(0, tiles.size()):
        # get the Item Name as a string to use as a dictionary key in idsOfNames
        var item_name = tiles[i]["ITEM_NAME"]
        # if it exists, then presumably there is an error in the ShapeDatabase
        # (or an error in belief that different swipes produce different arrays)
        idsOfNames[item_name] = i
    print(idsOfNames)

func id_of_name(name):
    return idsOfNames[name]