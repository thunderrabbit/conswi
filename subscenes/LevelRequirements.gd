#    Copyright (C) 2020  Rob Nugen
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

extends MarginContainer

const SwipeShape = preload("res://subscenes/FingerSwipeShape.tscn")

signal requirements_shown

var level_requirements				# will point to the dictionary inside level
var array_of_required_names = []	# so we can loop through (need to keep so we can keep track of which one to display next)
var array_of_visible_names = []     # so we know what to move when one is erased
var location_of_required_shape = {}	# so we know where to display shape
var pixel_width_of_required_shape = {}   # so we know how far to bring them back when a shape is finished
var required_shapes_hud = {}		# so we can update the shapes as swipes happen
var currently_showing_shape = null	# so we can come back and know what shape to shrink
var currently_showing_name = null	# so we can look up where to show it

func when_finished_callback(gameHUDScene):
    connect("requirements_shown", gameHUDScene, "showed_level_requirements")

# first, just get an array of names that we can slowly loop through
# and display each required shape
func show_level_requirements(level_requirements):
    reset_everything()

    self.level_requirements = level_requirements   # point to dictionary in level

    # Calculate the location of first (0th) requirement
    var level_requirement_latest_pixels = Helpers.slot_to_pixels(Vector2(0,1)) # (0,0) = (left, top (overlaps incoming queue))

    # loop through `level_requirements` defined in /levels/___World/normal_nn.gd
    for reqd_name in self.level_requirements:
        array_of_required_names.append(reqd_name)     # save the name so display_next_requirement knows what to do
        array_of_visible_names.append(reqd_name)      # save the name so we can move requirements when others are erased
        location_of_required_shape[reqd_name] = level_requirement_latest_pixels  # dictionary of required shapes so collected swipes shrink to the correct location

        # calculate width of this piece so we know where to put next piece
        var width_of_shape = ShapeShifter.getWidthOfShapeName("one_square")   # width in 'tiles' e.g. 1 for 'ta3' or 3 for 'bo3'
        var adjusted_width_of_shape_in_pixels = floor(Helpers.width_to_pixels(width_of_shape,G.REQ_SHAPE_SHRINK_FACTOR))  # scalar just for width
        pixel_width_of_required_shape[reqd_name] = adjusted_width_of_shape_in_pixels  # subsequent shapes move this far to account for this shape being removed from list
        level_requirement_latest_pixels = level_requirement_latest_pixels + Vector2(adjusted_width_of_shape_in_pixels,0)  # location for next piece (if any)

    # now that we know what we require, start showing them one by one
    display_next_requirement()

# Used by GameScene to know where swipe shrink animation should end
func required_swipe_location(swipe_name):
    return location_of_required_shape[swipe_name]

func reset_everything():
    remove_old_requirements()
    self.level_requirements = {}
    array_of_required_names = []
    array_of_visible_names = []
    location_of_required_shape = {}
    pixel_width_of_required_shape = {}
    required_shapes_hud = {}

func remove_old_requirements():
    for required in required_shapes_hud:
        required_shapes_hud[required].queue_free()				# remove piece from screen

# will start the next requirement to display itself and wait for callback
func display_next_requirement():
    # if no level_requirements, call back to GameScene to start playing
    if array_of_required_names.size() == 0:
        print("did not find any more level_requirements")
        emit_signal("requirements_shown")
    else:
        # get first requirement in array
        currently_showing_name = array_of_required_names.front()
        # wipe it from array so we don't show it again
        array_of_required_names.pop_front()
        # look up how many are required
        var reqd_qty = self.level_requirements[currently_showing_name]

        currently_showing_shape = SwipeShape.instance()

        required_shapes_hud[currently_showing_name] = currently_showing_shape
        # after shape has been displayed (and number counted down) we will shrink the shape
        currently_showing_shape.connect("displayed_shape",self,"shape_has_been_displayed")
        # note we are using ShapeShifter and Helpers here
        # but not sending them in because I do not know how to send them in via connect().
        # Godot makes it simple to not worry about this, so Globals it is.
        # if you want to worry about it, look at shape_has_been_displayed()
        # and retool how this function is called
        var count_tiles_this_shape = currently_showing_shape.set_shape(ShapeShifter.getBitmapOfSwipeName("one_square"),TileDatabase.id_of_name(currently_showing_name))
        var swipe_dimensions = currently_showing_shape.dimensions
        currently_showing_shape.set_position(Helpers.offset_bottom_center_slot_in_pixels(swipe_dimensions))
        add_child(currently_showing_shape)
        currently_showing_shape.display_quantity(reqd_qty)

func shape_has_been_displayed():
    # once shape has been shrunk, go to above function to display next shape
    currently_showing_shape.connect("shrunk_shape",self,"display_next_requirement")
    currently_showing_shape.shrink_shape(location_of_required_shape[currently_showing_name])

func swiped_piece(piece_name):
    var num_required = 0
    if self.level_requirements.has(piece_name):
        num_required = self.level_requirements[piece_name]
    print("%d %s required" %[num_required, piece_name])
    if num_required > 0:
        self.level_requirements[piece_name] = num_required - 1
    return (num_required > 0)		# return true if piece was required

func _removed_name_from_visible(name):
    print("need to remove '", name, "' from this array")
    print(array_of_visible_names)
    var key_to_remove = 0
    for i in range(0, array_of_visible_names.size()):
        if array_of_visible_names[i] == name:
            key_to_remove = i

    var slide_left_n_pixels = pixel_width_of_required_shape[name]
    print("removing a thing this wide ", slide_left_n_pixels)

    for i in range(key_to_remove + 1, array_of_visible_names.size()):
        var moving_name = array_of_visible_names[i]
        print("moving ", moving_name)
        print(required_shapes_hud[moving_name])
        var slide_duration = (i - key_to_remove) * 0.21 # slow down a bit for each one so they sorta appear to move after one another
        required_shapes_hud[moving_name].move_shape_left(slide_left_n_pixels, slide_duration) #  visually move the shapes
        location_of_required_shape[moving_name].x = location_of_required_shape[moving_name].x - slide_left_n_pixels   # updates location for collected swipes to go when they shrink

    array_of_visible_names.erase(name)   # So we don't try to move it again

# Removes swipes that have been correctly swiped
func clarify_level_requirements():
    for name in self.level_requirements:
        var required = required_shapes_hud[name]
        required.spinner.set_value(self.level_requirements[name])
        if self.level_requirements[name] == 0:
            self.level_requirements.erase(name)	# remove requirement from level
            print("removed ", name)
            print(name, " was this wide ", self.pixel_width_of_required_shape[name])
            required_shapes_hud.erase(name)		# so we won't try to hide Deleted nodes in remove_old_requirements()
            required.hide()				# remove piece from screen
            required.queue_free()
            _removed_name_from_visible(name)
    if self.level_requirements.empty():
        emit_signal("achieved_three_levels")  # This is not yet used

# count how many swipes are required to get three levels.  Called by Game.md when starting a level
func count_level_requirements():
    var total_swipes_required_for_three_levels = 0
    for name in self.level_requirements:
        var swipes_required_for_name = self.level_requirements[name]
        total_swipes_required_for_three_levels = total_swipes_required_for_three_levels + swipes_required_for_name
    return total_swipes_required_for_three_levels
