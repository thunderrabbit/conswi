#    Level 11
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

extends "DogLevel.gd"

func _init():
# Level 11
# playable pieces: dog, cat, leopard
    gravity_timeout = 0.60
    max_tiles_avail = 200
    tiles = { "dog":2, "cat":2, "leopard":2 }
    time_limit_in_sec = 360
    star_requirements = {
                          "dogl3downshared2up":2,
                          "dogl3upshared2down":2,
                          "dogl2downshared3up":2,
                          "dogl2upshared3down":2,
                        }
    required_tiles = { "dog":30, "cat":30, "leopard":30 }
