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
var bottom_left_position     # for back button
var bottom_right_position    # for next button and retry button

func set_game_scene(my_game_scene):
    game_scene = my_game_scene

func calc_button_locations():
    # Called every time the node is added to the scene.
    # Initialization here
    self.bottom_left_position = Helpers.slot_to_pixels(Vector2(0,12))
    self.bottom_right_position = Helpers.slot_to_pixels(Vector2(4.4,12), true)   # true allows fractional slots
    pass

func show_lose_buttons_on_bottom():
#    var fill_this_fraction_of_third_of_screen = 0.85
    $NextLevel.hide()
 #   scale_button_almost_1_third_screen($LevelSelect, fill_this_fraction_of_third_of_screen)
  #  anchor_bottom_left($LevelSelect)
    $LevelSelect.set_normal_texture(preload("res://images/buttons/lose_back@3x.png")) #  the lose background was in BackgroundScript.gd but might move it here
    $LevelSelect.show()
    $LevelSelect.set_position(self.bottom_left_position)
    make_button_move($LevelSelect,self.bottom_left_position)
 #   scale_button_almost_1_third_screen($TryAgain, fill_this_fraction_of_third_of_screen)
 #   anchor_bottom_left($TryAgain)
    $TryAgain.show()
    $TryAgain.set_position(self.bottom_right_position)   ### This does not work!!  WHY????
    make_button_move($TryAgain,self.bottom_right_position)   ### This makes it work.  WHY??

### make_button_move is ONLY because set_position does not seem to work on the buttons.  I guess it is some problem with anchors, but I am stumped.
func make_button_move(shape, go_to_loc, duration = 1.21):
    var effect = Tween.new()
    add_child(effect)
    effect.interpolate_property(shape, "rect_position",
            shape.get_position(), go_to_loc, duration,
            Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
    effect.start()
    
func show_win_buttons_on_bottom():
    $TryAgain.hide()
    $NextLevel.show()
    $NextLevel.set_position(self.bottom_right_position)
    make_button_move($NextLevel,self.bottom_right_position)  
    
    $LevelSelect.set_normal_texture(preload("res://images/buttons/win_back@3x.png")) #  the lose background was in BackgroundScript.gd but might move it here
    $LevelSelect.show()
    $LevelSelect.set_position(self.bottom_left_position)
    make_button_move($LevelSelect,self.bottom_left_position)

func level_over_reason(reason):
    print(reason)
    calc_button_locations()
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

func _on_TryAgain_button_up():
    get_node("LevelOverOverlay").hide() #  the lose background was in BackgroundScript.gd but might move it here
    game_scene.requested_replay_level()

func _on_LevelSelect_button_up():
    Helpers.clear_game_board() # so no tiles appear behind the main menu buttons
    get_node("LevelOverOverlay").hide() #  the lose background was in BackgroundScript.gd but might move it here
    get_node("/root/SceneSwitcher").goto_scene("res://LevelSelect/LevelSelectScene.tscn")

func _on_WorldMenu_pressed_aintused():
    Helpers.clear_game_board() # so no tiles appear behind the main menu buttons
    get_node("LevelOverOverlay").hide() #  the lose background was in BackgroundScript.gd but might move it here
    get_node("/root/SceneSwitcher").goto_scene("res://NightDayMainSplash/NightDayMainSplash.tscn")

func _on_NextLevel_button_up():
    get_node("LevelOverOverlay").hide() #  the lose background was in BackgroundScript.gd but might move it here
    game_scene.requested_next_level()
