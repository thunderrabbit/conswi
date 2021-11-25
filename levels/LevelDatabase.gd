#    Copyright (C) 2021  Rob Nugen
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

var animal_names = {}

func _ready():
    if animal_names.empty():
        # these e.g. G.TYPE_BEAR are defined in helpers/Globals.gd
        animal_names[G.TYPE_PANDA] = "Panda"
        animal_names[G.TYPE_BEAR] = "Bear"
        animal_names[G.TYPE_COW] = "Cow"    # directory inside /levels directory
        animal_names[G.TYPE_DOG] = "Dog"    # "DogWorld" is directory in /levels directory
        animal_names[G.TYPE_MONKEY] = "Monkey"
        animal_names[G.TYPE_SHEEP] = "Sheep"
        animal_names[G.TYPE_PIG] = "Pig"
        animal_names[G.TYPE_CAT] = "Cat"    # CatWorld and below do not exist yet
        animal_names[G.TYPE_LION] = "Lion"
        animal_names[G.TYPE_RABBIT] = "Rabbit"
        animal_names[G.TYPE_TIGER] = "Tiger"

# used by Game.gd to know which bgm to start and stop
func getAnimalOfId(which_world_id):
    return animal_names[which_world_id]

# If a too-large level_num is sent, this will
# spin down through smaller numbers to find one.
# Define levels in `levels/` directory
# This is never called without params, but I am hinting to future me what must be sent here
func getExistingLevelGDScript(which_world_id = G.TYPE_DOG, level_num = 1):
    var level_difficulty = "normal"   # TODO add Settings (same as Helpers.gd) and put "normal" into it
                                    #     then Scene > Project Settings > Autoload "Settings"
    var world_name = animal_names[which_world_id] + "World"
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
