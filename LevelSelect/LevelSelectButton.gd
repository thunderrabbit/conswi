#    Copyright (C) 2022  Rob Nugen
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
#    LevelSelectButton instances are used on the level select screen
#
#    They are designed to show "stars" to indicate how well each level was passed.
#    The stars will be animal faces corresponding to which World the player is in.
#
#    World one is Dog world, so up to three Dog faces will show up on each button.
#
#####################################################################################
extends TextureButton

var num_stars = 0

# must be done before we can set the button type
# because each button type is split into images based on number of stars
func set_num_stars(num):
    num_stars = num

func set_level(level, type):  #  e.g.  5,   G.TYPE_DOG
    var my_type = type
    var my_type_string = TileDatabase.tiles[my_type]["ITEM_NAME"]
    # we do not need to remember the level because
    # LevelSelectScene links the button press to the respective level select
    print ("res://images/world_skins/" + 
                            my_type_string + "/" +
                            my_type_string + "_level_" +
                            String(level) + "@3x.png");
    var path_to_num = String("res://images/world_skins/" + 
                            my_type_string + "/" +
                            my_type_string + "_level_" +
                            String(level) + "@3x.png");
    $level_number.set_texture(load(path_to_num))

func set_button_type(type):   #  e.g. G.TYPE_DOG
    var my_type = type
    var my_type_string = TileDatabase.tiles[my_type]["ITEM_NAME"]
    # background path example "res://images/world_skins/dog/dog_level_2star@3x.png"
    var background = String("res://images/world_skins/" +
                            my_type_string + "/" +
                            my_type_string + "_level_" +
                            String(num_stars) + "star@3x.png")
    set_normal_texture(load(background))

