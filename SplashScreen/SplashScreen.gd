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
var gowhere

var splash_texture_1 = preload("res://images/Folder_2.5/01_space@3x.png")
var splash_texture_2 = preload("res://images/Folder_2.5/02planet@3x_.png")
var splash_texture_3 = preload("res://images/Folder_2.5/03animal living happily@3x.png")
var splash_texture_4 = preload("res://images/Folder_2.5/04planet disaster@3x.png")
var splash_texture_5 = preload("res://images/Folder_2.5/05animal suffering@3x.png")
# deemed to not make sense var splash_texture_6 = preload("res://images/Folder_2.5/06_wide view@3x.png")

func _ready():
    $Timer.set_wait_time(G.splashscreen_timeout)
    $Timer.start()

func _on_SplashScreen_Timer_timeout():
    if G.current_screen < G.max_splash_screens:
        G.current_screen = G.current_screen + 1
        $Timer.start()
    else:
        $PawAgreeButton.visible = true

    if G.current_screen > 0 and G.current_screen <= G.max_splash_screens:
        $StoryOverlay.visible = true

    if G.current_screen == 1:
        $StoryOverlay.texture = splash_texture_1
    elif G.current_screen == 2:
        $StoryOverlay.texture = splash_texture_2
    elif G.current_screen == 3:
        $StoryOverlay.texture = splash_texture_3
    elif G.current_screen == 4:
        $StoryOverlay.texture = splash_texture_4
    elif G.current_screen == 5:
        $StoryOverlay.texture = splash_texture_5


func _on_PawAgree_button_up():
        gowhere = "res://NightDayMainSplash/NightDayMainSplash.tscn"
        SceneSwitcher.goto_scene(gowhere)
