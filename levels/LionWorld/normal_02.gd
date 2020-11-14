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
    max_tiles_avail = 3000
    time_limit_in_sec = 3000
    width = 7    # This is a proof of concept.  Erase to make it 7 (level/NormalLevel.gd value)
    star_requirements = { "ta3":5,
                          "bo3":2,
                        }
    required_tiles = {
             "lion": 5,
            }
    show_finger = true			# On early levels, only with straight swipes
