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

extends Node2D

var game_scene

func set_game_scene(my_game_scene):
    game_scene = my_game_scene

func _ready():
    # Called every time the node is added to the scene.
    # Initialization here
    pass

func level_over_reason(reason):
    print(reason)
    # Feb 2020 turn detailed failure to just have win or lose.
    # This is effed because the images are full BG images, but the node is "LevelOverTitle"
    if reason == G.LEVEL_WIN:
        get_node("LevelOverTitle").hide()   # it is already hidden in the 2D scene just reiterate here
        get_node("LevelOverOverlay").set_texture(preload("res://images/level_over/winningillustration@3x.png"))
        get_node("LevelOverOverlay").show() #  the lose background was in BackgroundScript.gd but might move it here
    if reason == G.LEVEL_NO_ROOM:
        get_node("LevelOverTitle").hide()   # switch to show in case we add lose titles
        get_node("LevelOverOverlay").set_texture(preload("res://images/level_over/failedillustration@3x.png")) #  the lose background was in BackgroundScript.gd but might move it here
        get_node("LevelOverOverlay").show() #  the lose background was in BackgroundScript.gd but might move it here
    if reason == G.LEVEL_NO_TIME:
        get_node("LevelOverTitle").hide()   # switch to show in case we add lose titles
        get_node("LevelOverOverlay").set_texture(preload("res://images/level_over/failedillustration@3x.png")) #  the lose background was in BackgroundScript.gd but might move it here
        get_node("LevelOverOverlay").show() #  the lose background was in BackgroundScript.gd but might move it here
    if reason == G.LEVEL_NO_TILES:
        get_node("LevelOverTitle").hide()   # switch to show in case we add lose titles
        get_node("LevelOverOverlay").set_texture(preload("res://images/level_over/failedillustration@3x.png")) #  the lose background was in BackgroundScript.gd but might move it here
        get_node("LevelOverOverlay").show() #  the lose background was in BackgroundScript.gd but might move it here

func _on_TryAgain_pressed():
    get_node("LevelOverOverlay").hide() #  the lose background was in BackgroundScript.gd but might move it here
    game_scene.requested_replay_level()

func _on_MainMenu_pressed():
    Helpers.clear_game_board() # so no tiles appear behind the main menu buttons
    get_node("LevelOverOverlay").hide() #  the lose background was in BackgroundScript.gd but might move it here
    get_node("/root/SceneSwitcher").goto_scene("res://LevelSelect/LevelSelectScene.tscn")

func _on_NextLevel_pressed():
    get_node("LevelOverOverlay").hide() #  the lose background was in BackgroundScript.gd but might move it here
    game_scene.requested_next_level()
