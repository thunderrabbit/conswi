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

extends Node

# See commit fe6c6bf99ac3c95e500c80c02d5506e4313bb366
# For the original naming conventions
# The first digit in each array is the width of the shape.
# Subsequent digits are binary on/off
# e.g. [2,1,1] is a horizontal bar width 2.   [1,1,1] is a vertical bar height 2.
# The layout of the arrays below are ignored by computer, but hopefully useful for humans.
var shapes = {
    # one_square is for displaying level_requirements.  It is not an actual swipe
    "one_square": [1,
                   1],
}

var named_swipes_gds = preload("res://helpers/named_swipes/named_swipes.gd")
var len_8_swipes_gds = preload("res://helpers/named_swipes/len_8_swipes.gd")

func _ready():
    var named_swipes = self.named_swipes_gds.new()
    var len_8_swipes = self.len_8_swipes_gds.new()    

    for shapeName in named_swipes.named_swipes.keys():
        ShapeDatabase.shapes[shapeName] = named_swipes.named_swipes[shapeName]

    for shapeName in len_8_swipes.len_8_swipes.keys():
        ShapeDatabase.shapes[shapeName] = len_8_swipes.len_8_swipes[shapeName]


