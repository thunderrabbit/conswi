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

# These are basically the same names as in Globals.gd
# But I am not sure if those Globals are useful for GameScene,
# much less this scene.  I am just creating class vars
# here so it is clear that they are only used here.
# Feel free to arrange these buttons in a better way.

const SLOT_SIZE       = 140
var left_space        = 70
var top_space         = 190
var slot_gap          = 60
var slot_gap_h        = slot_gap
var slot_gap_v        = slot_gap * 2
var buttons_across    = 3
var num_buttons       = 12
var world_name        = 0

const LevelSelectButton = preload("LevelSelectButton.tscn")

func _init():
	var world_type = get_world_type()
	set_world_background(world_type)
	add_buttons_to_scene(world_type)

func get_world_type():
	# Helpers.requested_world was set by WorldSelectScene
	return Helpers.requested_world		# eventually load from local memory

func set_world_background(world_type):
	world_name = TileDatabase.tiles[world_type]["ITEM_NAME"]
	print("Starting world " + world_name)
	Background.set_background(world_type)
	pass

func add_buttons_to_scene(button_type):
	var button_loc = Vector2(0,0)
	for level in range(1,num_buttons+1):
		button_loc = level_to_pixels(level)
		var level_but = LevelSelectButton.instance()
		level_but.set_position(button_loc)
		level_but.set_level(level)
		level_but.set_size(Vector2(SLOT_SIZE,SLOT_SIZE))
		level_but.set_num_stars(Savior.read_num_stars(self.get_world_type(),level))
		level_but.set_button_type(button_type)
		level_but.scale_to(Vector2(0.5,0.5))
		level_but.connect("pressed",self,"_on_Button_pressed",[level])
		add_child(level_but)

func level_to_pixels(level):
	# level-1 because we start with 1 above.  Otherwise gap appears in top left corner
	level = level - 1
	var slot = Vector2(level % buttons_across, level / buttons_across)
	return Vector2(left_space+(SLOT_SIZE + slot_gap_h)*(slot.x),
	                top_space+(SLOT_SIZE + slot_gap_v)*(slot.y))

func _on_Button_pressed(level):
	Helpers.requested_level = level
	get_node("/root/SceneSwitcher").goto_scene("res://Game.tscn")
