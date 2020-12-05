#    Copyright (C) 2020  Rob Nugen
#
#    ShapeDatabase.gd gives names to swipes to help define levels
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

#    The swipes are defined in other files in /helpers/named_swipes/ then collected in this dictionary
var shapes = {
    # one_square is for displaying level_requirements.  It is not an actual swipe
    "one_square": [1,
                   1],
}

var named_swipes_gds = preload("res://helpers/named_swipes/named_swipes.gd")
var len_8_swipes_gds = preload("res://helpers/named_swipes/len_8_swipes.gd")

# Basically merge dictionaries defined in files above into one dictionary
# ShapeDatabase.shapes determines which swipes can be detected in the game.
func collect_swipes(named_swipes_dict: Dictionary):
    for shapeName in named_swipes_dict.named_swipes.keys():
        ShapeDatabase.shapes[shapeName] = named_swipes_dict.named_swipes[shapeName]

func _ready():
    var named_swipes = self.named_swipes_gds.new()
    var len_8_swipes = self.len_8_swipes_gds.new()

    collect_swipes(named_swipes)
    collect_swipes(len_8_swipes)
