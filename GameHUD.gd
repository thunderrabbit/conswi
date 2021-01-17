#    Copyright (C) 2021 Rob Nugen
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
var buttons                 # Steering Pad / Start buttons
var level_reqs              # HUD showing requirements for passing the level
var star_reqs               # HUD showing requirements for getting 3 stars
var stars_after_level       # Show stars after level is over
var saved_tiles             # Show saved tiles
var _current_level          # so we can call Star requirements AFTER Level requirements

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
    add_child(self.saved_tiles)

func showed_star_requirements():
    print("STAR Requirements were shown")
#    self.show_level_requirements(self._current_level)
    self.game.continue_start_level()

func show_star_requirements(current_level):
    self.star_reqs.show_finger_ka(current_level.show_finger)
    self.star_reqs.show_star_requirements(current_level.star_requirements)

func showed_level_requirements():
    print("LEVEL Requirements were shown")
    self.show_star_requirements(self._current_level)
#    self.game.continue_start_level()

func show_level_requirements(current_level):
    self.level_reqs.show_level_requirements(current_level.required_tiles)

func startLevel(current_level):
    self.buttons.prepare_to_play_level()
    self._current_level = current_level
    # These show level requirements, which takes time
    # after these animations complete, continue_start_level()
    # is called above by self.game.continue_start_level
    self.show_level_requirements(current_level)

func remove_all_requirements():
    level_reqs.reset_everything()
    star_reqs.reset_everything()

func hide_labels():
    self.stars_after_level._hide_everything()

# wrapper so GameSwipeDetector knows less about internals
func saved_n_tiles_of_type(n, tile_type):
    level_reqs.saved_n_tiles_of_type(n, tile_type)

func clarify_requirements():
    print("game hud clarifying requirements")
    star_reqs.clarify_star_requirements()
    level_reqs.clarify_level_requirements()
