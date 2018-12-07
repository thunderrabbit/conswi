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

extends Node

const Buttons = preload("res://subscenes/Buttons.gd")

var game
var buttons					# Steering Pad / Start buttons

func _init():
	self.buttons = Buttons.new()			# Buttons pre/post level

func addHUDtoGame(game):
	self.game = game
	# buttons are kinda like a HUD but for input, not output
	self.buttons.set_game_scene(self.game)
	add_child(self.buttons)

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
