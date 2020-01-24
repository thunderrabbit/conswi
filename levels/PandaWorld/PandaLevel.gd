#    Sends panda tiles to any level that extends (inherits) this class
#
#    Copyright (C) 2019  Rob Nugen
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
#   Eventually I need to figure out a way to succinctly tell how many of each type of animal to show
#
#   It is easy enough to write it, but then how to handle the information.  Maybe I can just push them
#   into an array and randomize the array.
#
#####################################################################################
extends "../NormalLevel.gd"

func _init():
     tiles = {"panda":1}
