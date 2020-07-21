#    Copyright (C) 2020  Rob Nugen
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

extends MarginContainer

var game_scene
var _buttons_across = 3

func set_game_scene(my_game_scene):
    game_scene = my_game_scene

func _ready():
    # Called every time the node is added to the scene.
    # Initialization here
    pass

func percent_of_1_third_screen_width(percent):
    return G.OneNthOfScreenWidth(3) * percent

## button is any container?
## percent 0.9 -->  0.9 * 1/3 of screen width (gives a bit of a gap)
func scale_button_almost_1_third_screen(button, fraction):
    var button_actual_width = button.get_size().x
    print(button_actual_width) # hope to be 260 or so
    var desired_width = percent_of_1_third_screen_width(fraction)
    print("desired_width = " , desired_width)
    var scale = desired_width / button_actual_width
    print(scale)
    button.set_scale(Vector2(scale, scale))
    
func anchor_bottom_left(button):
    button.anchr = 1
#    button.anchor_left = 0
    

func show_lose_buttons_on_bottom():
#    var fill_this_fraction_of_third_of_screen = 0.85
    $LevelEndedButtonsContainer/NextLevel.hide()
 #   scale_button_almost_1_third_screen($LevelSelect, fill_this_fraction_of_third_of_screen)
  #  anchor_bottom_left($LevelSelect)
    $LevelEndedButtonsContainer/LevelSelect.show()
 #   scale_button_almost_1_third_screen($TryAgain, fill_this_fraction_of_third_of_screen)
 #   anchor_bottom_left($TryAgain)
    $LevelEndedButtonsContainer/TryAgain.show()
#    scale_button_almost_1_third_screen($WorldMenu, fill_this_fraction_of_third_of_screen)
 #   anchor_bottom_left($WorldMenu)
    $LevelEndedButtonsContainer/WorldMenu.show()

func show_win_buttons_on_bottom():
    $LevelEndedButtonsContainer/TryAgain.hide()
    $LevelEndedButtonsContainer/NextLevel.show()
    $LevelEndedButtonsContainer/WorldMenu.hide()
    $LevelEndedButtonsContainer/LevelSelect.show()

func level_over_reason(reason):
    print(reason)
    # Feb 2020 turn detailed failure to just have win or lose.
    # This is effed because the images are full BG images, but the node is "LevelOverTitle"
    if reason == G.LEVEL_WIN:
        show_win_buttons_on_bottom()
        get_node("LevelOverTitle").hide()   # it is already hidden in the 2D scene just reiterate here
        get_node("LevelOverOverlay").set_texture(preload("res://images/level_over/winningillustration@3x.png"))
        get_node("LevelOverOverlay").show() #  the lose background was in BackgroundScript.gd but might move it here
    if reason == G.LEVEL_NO_ROOM:
        show_lose_buttons_on_bottom()
        get_node("LevelOverTitle").hide()   # switch to show in case we add lose titles
        get_node("LevelOverOverlay").set_texture(preload("res://images/level_over/failedillustration@3x.png")) #  the lose background was in BackgroundScript.gd but might move it here
        get_node("LevelOverOverlay").show() #  the lose background was in BackgroundScript.gd but might move it here
    if reason == G.LEVEL_NO_TIME:
        show_lose_buttons_on_bottom()
        get_node("LevelOverTitle").hide()   # switch to show in case we add lose titles
        get_node("LevelOverOverlay").set_texture(preload("res://images/level_over/failedillustration@3x.png")) #  the lose background was in BackgroundScript.gd but might move it here
        get_node("LevelOverOverlay").show() #  the lose background was in BackgroundScript.gd but might move it here
    if reason == G.LEVEL_NO_TILES:
        show_lose_buttons_on_bottom()
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

func _on_WorldMenu_pressed():
    Helpers.clear_game_board() # so no tiles appear behind the main menu buttons
    get_node("LevelOverOverlay").hide() #  the lose background was in BackgroundScript.gd but might move it here
    get_node("/root/SceneSwitcher").goto_scene("res://NightDayMainSplash/NightDayMainSplash.tscn")

func _on_NextLevel_pressed():
    get_node("LevelOverOverlay").hide() #  the lose background was in BackgroundScript.gd but might move it here
    game_scene.requested_next_level()
