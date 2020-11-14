#    Copyright (C) 2020 Rob Nugen
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
const StarRequirements = preload("res://subscenes/StarRequirements.tscn")
const LevelRequirements = preload("res://subscenes/LevelRequirements.tscn")
const StarsAfterLevel = preload("res://subscenes/LevelEndedStars.tscn")
const SavedTiles = preload("res://subscenes/SpinnerLabel.tscn")

var game
var buttons					# Steering Pad / Start buttons
var level_reqs				# HUD showing requirements for passing the level
var star_reqs				# HUD showing requirements for getting 3 stars
var stars_after_level		# Show stars after level is over
var saved_tiles             # Show saved tiles

func addHUDtoGame(game):
    self.game = game

    # buttons are kinda like a HUD but for input, not output
    self.buttons = Buttons.new()			# Buttons pre/post level
    self.buttons.set_game_scene(self.game)
    add_child(self.buttons)

    level_reqs = LevelRequirements.instance()
    level_reqs.when_finished_callback(self)
    add_child(level_reqs)

    star_reqs = StarRequirements.instance()
    star_reqs.when_finished_callback(self)
    add_child(star_reqs)

    self.stars_after_level = StarsAfterLevel.instance()
    self.stars_after_level.set_game_scene(self.game)
    add_child(self.stars_after_level)

    self.saved_tiles = SavedTiles.instance()
    self.saved_tiles.anchor_left = G.Saved_Tiles_Anchor_Left
    self.saved_tiles.anchor_top = G.Saved_Tiles_Anchor_Top
    add_child(self.saved_tiles)

func showed_star_requirements():
    print("STAR Requirements were shown")
    self.game.continue_start_level()

func show_star_requirements(current_level):
    self.star_reqs.show_finger_ka(current_level.show_finger)
    self.star_reqs.show_star_requirements(current_level.star_requirements)

func startLevel(current_level):
    self.buttons.prepare_to_play_level()

    # These show level requirements, which takes time
    # after these animations complete, continue_start_level()
    # is called above by self.game.continue_start_level
    self.show_star_requirements(current_level)
