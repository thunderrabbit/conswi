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

extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
    # Called when the node is added to the scene for the first time.
    SoundManager.play_bgm("Menu Background")
    HUD.hideBottomButtons()

func world_button_clicked(selected_world_type):
#    print(TileDatabase.tiles[selected_world_type]["ITEM_NAME"])
    SoundManager.stop("Menu Background")
    Helpers.requested_world = selected_world_type
    HUD.showBottomButtons()
    get_node("/root/SceneSwitcher").goto_scene("res://LevelSelect/LevelSelectScene.tscn")
