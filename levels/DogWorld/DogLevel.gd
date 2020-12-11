#    Sends dog tiles to any level that extends (inherits) this class
#
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
extends "../NormalLevel.gd"

func _init():
    tiles = {"dog":3,"cow":0,"bear":0,"panda":0}   # these are ratios. (3 parts dog, 0 parts cow 0 parts bear, 0 parts panda) => 100% dog
   # fill_level = true    # make it easy to test etc
