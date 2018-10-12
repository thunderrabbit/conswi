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

const SteeringPad = preload("res://subscenes/SteeringPad.tscn")
const EndLevelBut = preload("res://subscenes/LevelEndedButtons.tscn")
var parent_scene
var endLevelButtons = null
var steering_pad = null

func _init():
	steering_pad = SteeringPad.instance()
	add_child(steering_pad)

	endLevelButtons = EndLevelBut.instance()
	add_child(endLevelButtons)

func grok_input(boolean):
	steering_pad.set_process_input(boolean)
	endLevelButtons.set_process_input(boolean)

func set_game_scene(game_scene):
	parent_scene = game_scene
	steering_pad.set_game_scene(parent_scene)
	endLevelButtons.set_game_scene(parent_scene)

func prepare_to_play_level(level):
	print("buttons preparing for level ", level)
	# the steering pad is the left/right buttons at bottom
	steering_pad.set_position(Helpers.steering_pad_pixels())
	steering_pad.show()
	endLevelButtons.hide()

func level_ended(reason):
	steering_pad.hide()
	endLevelButtons.set_process_input(true)
	# removed set_alignment because it wasn't working when this was a ButtonGroup,
	# and now that this is a Node2D, it crashes the app
#	endLevelButtons.set_alignment(endLevelButtons.ALIGN_CENTER)
	endLevelButtons.level_over_reason(reason)
	endLevelButtons.show()

