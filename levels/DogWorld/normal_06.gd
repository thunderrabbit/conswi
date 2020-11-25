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

extends "DogLevel.gd"

func _init():
#playable pieces: dog

    max_tiles_avail = 100  
    tiles  = {"dog": 1}
    time_limit_in_sec = 300
    star_requirements = { "vertical3":3, "horizontal3":3,"vertical4":3, "horizontal4":3}
    required_tiles = { "dog":42 }
    show_unlock_image_after_level_won = "cat"