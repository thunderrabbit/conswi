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
const LevelRequirements = preload("res://subscenes/LevelRequirements.tscn")
const StarsAfterLevel = preload("res://subscenes/LevelEndedStars.tscn")

var game
var buttons					# Steering Pad / Start buttons
var level_reqs				# HUD showing level requirements
var stars_after_level		# Show stars after level is over


func _init():
	self.buttons = Buttons.new()			# Buttons pre/post level

func addHUDtoGame(game):
	self.game = game
	# buttons are kinda like a HUD but for input, not output
	self.buttons.set_game_scene(self.game)
	add_child(self.buttons)

	level_reqs = LevelRequirements.instance()
	level_reqs.set_game_scene(self.game)
	add_child(level_reqs)

	self.stars_after_level = StarsAfterLevel.instance()
	self.stars_after_level.set_game_scene(self.game)
	add_child(self.stars_after_level)

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
