#    Show Bottom Buttons on Level Select screen
#    Music, Back, etc
#
#    Copyright (C) 2019  Rob Nugen
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

extends Container

# LSBottomButtons are shown on the Level Select Screen

func _ready():
    print("hello from Level Select Bottom Buttons")
    pass

func _on_BackButton_pressed():
    print("bye from Level Select Bottom Buttons")
    get_node("/root/SceneSwitcher").goto_scene("res://NightDayMainSplash/NightDayMainSplash.tscn")
