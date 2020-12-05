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
    max_tiles_avail = 39999
    time_limit_in_sec = 300
    show_finger = true			# On early levels, only with straight swipes
    fill_level = false    # make it easy to test etc
    star_requirements = { "vertical3":1,"horizontal3":1,"vertical4":1,"horizontal4":1 }	# swipe these shapes to get 3 stars
    tiles  = {"panda":10,
                "bear":10,
                "cow":10,
                "dog":1,
                "monkey":1,
                "sheep":1,
                "pig":1,
                "cat":1,
                "lion":10,
                "rabbit":1,
                "tiger":1,
                "zebra":1,
                "leopard":1,
                "polar":1,
                "snake":1
                        }
    required_tiles = {
             "bear": 6,
             "lion": 6,
             "cow": 6,
             "panda": 6,
            }