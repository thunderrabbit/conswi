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

func _ready():
	var new_player = $SplashIcon
	new_player.set_tile_type(G.TYPE_DOG)
	new_player.set_scale(Vector2(5,5))
	new_player.set_position(OS.get_window_size()/2)

	$Timer.set_wait_time(G.splashscreen_timeout)
	$Timer.start()

func _on_SplashScreen_Timer_timeout():
	SceneSwitcher.goto_scene("res://LevelSelect/LevelSelectScene.tscn")