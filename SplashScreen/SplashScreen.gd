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

func _ready():
	$Timer.set_wait_time(G.splashscreen_timeout)
	$Timer.start()

func _on_SplashScreen_Timer_timeout():
	if G.current_screen < 2:
		gowhere = "res://SplashScreen/SplashScreenButton.tscn"
		G.current_screen = G.current_screen + 1
	else:
		gowhere = "res://LevelSelect/LevelSelectScene.tscn"

	SceneSwitcher.goto_scene(gowhere)
	
	

#	