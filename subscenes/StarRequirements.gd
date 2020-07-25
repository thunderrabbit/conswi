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

const SwipeShape = preload("res://subscenes/FingerSwipeShape.tscn")

signal levelwon
signal achieved_three_stars   # not yet connected, but will just trigger visual
signal requirements_shown

var star_requirements				# will point to the dictionary inside level
var array_of_required_names = []	# so we can loop through (need to keep so we can keep track of which one to display next)
var location_of_required_shape = {}	# so we know where to display shape
var required_shapes_hud = {}		# so we can update the shapes as swipes happen
var currently_showing_shape = null	# so we can come back and know what shape to shrink
var currently_showing_name = null	# so we can look up where to show it
var num_tiles_required = 0			# so LevelEndedStars knows how big bonus should be
var show_finger = false				# usually do not show swiping finger (just on first couple levels)

func set_game_scene(gameScene):
    connect("levelwon", gameScene, "_on_LevelWon")
    connect("requirements_shown", gameScene, "continue_start_level")

func show_finger_ka(show_finger):
    self.show_finger = show_finger

# first, just get an array of names that we can slowly loop through
# and display each required shape
func show_star_requirements(star_requirements):
    reset_everything()
    self.star_requirements = star_requirements   # point to dictionary in level
    for reqd_name in self.star_requirements:
        var num_required = location_of_required_shape.size()	# will determine where shape should be shown
        array_of_required_names.append(reqd_name)
        location_of_required_shape[reqd_name] = Helpers.slot_to_pixels(Vector2(num_required,1),G.REQ_SHAPE_SHRINK_LOCATION)
    # now that we know what we require, start showing them one by one
    display_next_requirement()

# Used by GameScene to know where swipe shrink animation should end
func required_swipe_location(swipe_name):
    return location_of_required_shape[swipe_name]

func reset_everything():
    remove_old_requirements()
    self.num_tiles_required = 0
    self.star_requirements = {}
    array_of_required_names = []
    location_of_required_shape = {}
    required_shapes_hud = {}

func remove_old_requirements():
    for required in required_shapes_hud:
        required_shapes_hud[required].queue_free()				# remove piece from screen

# will start the next requirement to display itself and wait for callback
func display_next_requirement():
    # if no star_requirements, call back to GameScene to start playing
    if array_of_required_names.size() == 0:
        print("did not find any more star_requirements")
        print("Total tiles required = ", self.num_tiles_required)
        emit_signal("requirements_shown")
    else:
        # get first requirement in array
        currently_showing_name = array_of_required_names.front()
        # wipe it from array so we don't show it again
        array_of_required_names.pop_front()
        # look up how many are required
        var reqd_qty = self.star_requirements[currently_showing_name]

        currently_showing_shape = SwipeShape.instance()
        currently_showing_shape.show_finger = self.show_finger

        required_shapes_hud[currently_showing_name] = currently_showing_shape
        # after shape has been displayed (and number counted down) we will shrink the shape
        currently_showing_shape.connect("displayed_shape",self,"shape_has_been_displayed")
        # note we are using ShapeShifter and Helpers here
        # but not sending them in because I do not know how to send them in via connect().
        # Godot makes it simple to not worry about this, so Globals it is.
        # if you want to worry about it, look at shape_has_been_displayed()
        # and retool how this function is called
        var count_tiles_this_shape = currently_showing_shape.set_shape(ShapeShifter.getBitmapOfSwipeName(currently_showing_name),Helpers.requested_world)
        var swipe_dimensions = currently_showing_shape.dimensions
        self.num_tiles_required = self.num_tiles_required + count_tiles_this_shape * reqd_qty
        currently_showing_shape.set_position(Helpers.offset_bottom_center_slot_in_pixels(swipe_dimensions))
        add_child(currently_showing_shape)
        currently_showing_shape.display_quantity(reqd_qty)

func shape_has_been_displayed():
    # once shape has been shrunk, go to above function to display next shape
    currently_showing_shape.connect("shrunk_shape",self,"display_next_requirement")
    currently_showing_shape.shrink_shape(location_of_required_shape[currently_showing_name])

func swiped_piece(piece_name):
    var num_required = 0
    if self.star_requirements.has(piece_name):
        num_required = self.star_requirements[piece_name]
    print("%d %s required" %[num_required, piece_name])
    if num_required > 0:
        self.star_requirements[piece_name] = num_required - 1
    return (num_required > 0)		# return true if piece was required

# THIS NO LONGER CHECKS IF WE WON
# But I am leaving it here because it correctly removes swipes that have been correctly swiped
func clarify_requirements():
    for name in self.star_requirements:
        var required = required_shapes_hud[name]
        required.spinner.set_value(self.star_requirements[name])
        if self.star_requirements[name] == 0:
            self.star_requirements.erase(name)	# remove requirement from level
            required_shapes_hud.erase(name)		# so we won't try to hide Deleted nodes in remove_old_requirements()
            required.hide()				# remove piece from screen
            required.queue_free()
    if self.star_requirements.empty():
        emit_signal("achieved_three_stars")  # use to be levelwon but now the total tiles swiped determines if level is won
