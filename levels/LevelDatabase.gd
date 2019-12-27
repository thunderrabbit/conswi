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

extends Node

const level_format = "res://levels/%s_%s_%02d.gd"		# normal_welcome_01

# If a too-large level_num is sent, this will
# spin down through smaller numbers to find one.
# Define levels in `levels/` directory
# This is never called without params, but I am hinting to future me what must be sent here
func getExistingLevelGDScript(level_num):
	var level_difficulty = "normal"		# TODO add Settings (same as Helpers.gd) and put "normal" and "welcome" into it
	var level_group = "welcome"			#      Scene > Project Settings > Autoload
	var level_name = ""

	var levelGDScript = null
	var sanityCheck = 100
	while levelGDScript == null:
		level_name = level_format % [level_difficulty, level_group, level_num]
		levelGDScript = load(level_name)
		level_num = level_num - 1
		sanityCheck = sanityCheck - 1
		if sanityCheck == 0:
			level_num = 1
		if sanityCheck < 0:
			print("This level name format isn't working ", level_name)
	print("starting Level ", level_name)
	return levelGDScript
