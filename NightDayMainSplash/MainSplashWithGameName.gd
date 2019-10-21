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

extends Sprite

var day_texture = preload("res://images/Folder_4/universal_background_day@3x.png")
var night_texture = preload("res://images/Folder_4/universal_background_night@3x.png")

func _ready():
	set_background()

# set_background keeps _ready() small
func set_background():
	var timeDict = OS.get_time();
	var hour = timeDict.hour;
	set_background_for_hour(hour)

# set_background_for_hour keeps things testable
func set_background_for_hour(var hour):
	if 6 <= hour && hour < 18:
		texture = day_texture
	else:
		texture = night_texture
