#    Script to handle Pause Popup over game
#
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

extends Popup

func _on_PauseButton_pressed():
	set_exclusive(true)
	popup()
	get_tree().set_pause(true)
	print("paused")

func _on_UnpauseButton_pressed():
	hide()
	get_tree().set_pause(false)
	print("unpaused")
