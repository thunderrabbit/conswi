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

extends Area2D

signal clicked
signal unclicked
signal entered
signal exited

var is_a_game_piece = true		# helps detect sprites for group actions
var is_swipable = false			# will prevent clicks from signalling GameScene
var tile_type = null
func _ready():
	self.connect("clicked", get_node("/root/GameNode2D/GameSwipeDetector"), "piece_clicked", [])
	self.connect("unclicked", get_node("/root/GameNode2D/GameSwipeDetector"), "piece_unclicked", [])
	self.connect("entered", get_node("/root/GameNode2D/GameSwipeDetector"), "piece_entered", [])
	self.connect("exited", get_node("/root/GameNode2D/GameSwipeDetector"), "piece_exited", [])

func set_tile_type(type):
	tile_type = type

# called after piece gets nailed to board
func become_swipable():
	# I would think set_process_input(false) should do the same thing
	# but it did not seem to work.
	is_swipable = true

func _on_PlayerArea2D_input_event( viewport, event, shape_idx ):
	if not is_swipable:
		return
	if event is InputEventScreenTouch or event is InputEventMouseButton:
		if event.pressed:
			emit_signal("clicked", Helpers.pixels_to_slot(get_position()), tile_type)
		else: # not event.pressed:
			emit_signal("unclicked")

func _on_PlayerArea2D_mouse_entered():
	if not is_swipable:
		return
	emit_signal("entered", Helpers.pixels_to_slot(get_position()), tile_type)

func _on_PlayerArea2D_mouse_exited():
	if not is_swipable:
		return
	emit_signal("exited", Helpers.pixels_to_slot(get_position()), tile_type)

