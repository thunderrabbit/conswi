#    Copyright (C) 2020  Rob Nugen
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

#####################################################################################
#
#  This is kinda like Globals, but for functions, most of which deal with placing tiles
#
#####################################################################################

extends Node

var local_required_tiles = {}         # our own copy of animals required
var local_saved_tiles = {}         # our own copy of animals required

func _ready():
    self.local_required_tiles = {}
    self.local_saved_tiles = {}

func assess_required_tiles(level_info):
    # https://godotengine.org/qa/19396/how-do-i-duplicate-a-dictionary-in-godot-3-0-alpha-2?show=56050#a56050
    self.local_required_tiles = level_info.required_tiles.duplicate()
    create_zero_version_of_dictionary(level_info.required_tiles, self.local_saved_tiles)

func create_zero_version_of_dictionary(source, target):
    for key in source:
        target[key] = 0

func print_all():
    print("saved")
    print(self.local_saved_tiles)
    print("required")
    print(self.local_required_tiles)

func tile_name(tile_type):
    return TileDatabase.tiles[tile_type].ITEM_NAME

func saved_n_tiles_of_type(n, tile_type):
    var tile_name = self.tile_name(tile_type)
    print(n, tile_name)
    self.local_saved_tiles[tile_name] = self.local_saved_tiles[tile_name] + n
    self.print_all()

func saved_enough_tiles_bool():
    for key in self.local_required_tiles:
        if self.local_saved_tiles[key] < self.local_required_tiles[key]:
            return false
    return true

func num_tiles_all_types():
    var total_tiles = 0
    for key in self.local_required_tiles:
        total_tiles = total_tiles + self.local_required_tiles[key]
    return total_tiles
    