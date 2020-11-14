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

extends "LionLevel.gd"

func _init():
    tiles = {"lion":9,"cow":1,"bear":1,"panda":1}
    max_tiles_avail = 8150
    time_limit_in_sec = 8390
    star_requirements = { "pink_floyd":1 }
    required_tiles = { "default":1, "cat":280 }   # NormalLevel.gd converts default to a quantity based on level