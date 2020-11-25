#    Copyright (C) 2020 Rob Nugen
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
    required_tiles = { "lion":75 } 
    max_tiles_avail = 1900
    gravity_timeout = 1
    time_limit_in_sec = 3390
    fill_level = true
    star_requirements = { "ribbondownright":1,
                            "ta3":1,
                            "vertical8":1,
                            "ta7":1,
                            "bo5":1,
                            "ta6":1,
                            "horizontal8":1,
                            "tallP":1,
                            "bo3":1,
                            "ta5":1,
                            "bo4":1,
                            "ta4":1,

                        }
