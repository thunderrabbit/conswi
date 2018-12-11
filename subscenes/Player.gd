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

const Segment = preload("res://tiles/Segment.tscn")

var mytile = null	# visible in queue, while moving, when nailed
var myshadow = null	# only visible when moving
var mytouchzone = null  # only after nailed
var my_position
var should_show_shadow = false
var nailed = false
var tile_type = null

func _ready():
	add_to_group("players")		# to simplify clearing game scene
	set_process_input(false)

func set_type(new_tile_type_ordinal):
	tile_type = new_tile_type_ordinal
	# instantiate 1 Tile each for our player and shadow.
	mytile = Segment.instance()
	mytile.set_tile_type(new_tile_type_ordinal)
	# add Tile to scene
	add_child(mytile)

	myshadow = Segment.instance()
	myshadow.set_tile_type(new_tile_type_ordinal)
	# Tell Tile to tell its sprite it's a shadow
	myshadow.is_shadow()
	add_child(myshadow)

# only the Player tiles will be set draggable (not the shadows)
# This is set to true by Game.gd
# This is set to false by Game via nail_player() down below
func set_draggable(candrag):
	mytile.set_draggable(candrag)

# update player sprite display
func set_player_position(player_position):
	my_position = player_position
	mytile.set_position(Helpers.slot_to_pixels(player_position))
	if not nailed:
		# TODO make Helpers.shadowheight or column height
		myshadow.set_position(Helpers.slot_to_pixels(Vector2(player_position.x, column_height(player_position.x))))   ## shadow
		if myshadow != null:
			if should_show_shadow:
				myshadow.show()
			else:
				myshadow.hide()

# player has been nailed so it should animate or whatever
func nail_player():
	# now that we are nailed, we cannot be dragged
	mytile.set_draggable(false)
	mytile.set_swipeable(true)
	
	# now that we are nailed, we have no shadow
	myshadow.queue_free()
	nailed = true

func column_height(column):
	var height = Helpers.slots_down-1
	for i in range(Helpers.slots_down-1,0,-1):
		if Helpers.board[Vector2(column, i)] != null:
			height = i-1
	return height

func move_down_if_room():
	var below_me = my_position + Vector2(0,1)
	if below_me.y < Helpers.slots_down:
		if Helpers.board[below_me] == null:
			Helpers.board[below_me] = self
			Helpers.board[my_position] = null
			set_player_position(below_me)

func set_show_shadow(should_i):
	should_show_shadow = should_i
	# set position forces shdadow to show up or not
	set_player_position(my_position)

func highlight():
	mytile.highlight()

func unhighlight():
	mytile.unhighlight()

func darken():
	mytile.darken()
#	mytile.clear_shapes()

func level_ended():
	if mytouchzone != null:
		mytouchzone.set_process_input(false)
		mytouchzone.set_pickable(false)
	darken()

func remove_yourself():
	remove_from_group("players")
	Helpers.board[my_position] = null
	mytile.start_swipe_effect()		# release yourself
