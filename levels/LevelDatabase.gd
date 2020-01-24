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

const level_format = "res://levels/%s/%s_%02d.gd"		# DogWorld/normal_01.gd

var world_names = {}

func _ready():
    if world_names.empty():
        # these e.g. G.TYPE_BEAR are defined in helpers/Globals.gd
        world_names[G.TYPE_PIG] = "pig_world"       # "pig_world" とか filenames do not exist yet
        world_names[G.TYPE_SHEEP] = "sheep_world"   #                  in the /levels directory
        world_names[G.TYPE_PANDA] = "panda_world"
        world_names[G.TYPE_DOG] = "DogWorld"    # "DogWorld" is directory in /levels directory
        world_names[G.TYPE_COW] = "CowWorld"    # directory inside /levels directory
        world_names[G.TYPE_CAT] = "cat_world"
        world_names[G.TYPE_BEAR] = "bear_world"
        world_names[G.TYPE_LION] = "lion_world"
        world_names[G.TYPE_MONKEY] = "monkey_world"
        world_names[G.TYPE_RABBIT] = "rabbit_world"
        world_names[G.TYPE_TIGER] = "tiger_world"

# If a too-large level_num is sent, this will
# spin down through smaller numbers to find one.
# Define levels in `levels/` directory
# This is never called without params, but I am hinting to future me what must be sent here
func getExistingLevelGDScript(which_world_id = TYPE_DOG, level_num = 1):
    var level_difficulty = "normal"   # TODO add Settings (same as Helpers.gd) and put "normal" into it
                                    #     then Scene > Project Settings > Autoload "Settings"
    var world_name = world_names[which_world_id]
    var level_name = ""

    var levelGDScript = null
    var sanityCheck = 20
    while levelGDScript == null:
        level_name = level_format % [world_name, level_difficulty, level_num]
        levelGDScript = load(level_name)
        level_num = level_num - 1
        sanityCheck = sanityCheck - 1
        if sanityCheck == 0:
            level_num = 1
        if sanityCheck < 0:
            print("This level name format isn't working ", level_name)
    print("starting Level ", level_name)
    return levelGDScript
