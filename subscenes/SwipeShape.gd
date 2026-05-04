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

extends Node2D

const sprite_script = preload("res://tiles/Segment.gd")
@onready var spinner = get_node("SpinnerLabel")
@onready var pauser = Timer.new()

func _ready():
    # Parent pauser so it's freed with this SwipeShape. Without this, gameplay
    # swipes (which never call _displayed_quantity) leak the Timer at exit.
    add_child(pauser)

var dimensions = Vector2(0,0)	# will tell the size of the shape
const tick_delay = 0.73	 * G.ofaster		# pause between countup qty
const pause_time = tick_delay	# pause after countup quantity
const numberic_offset_pixels = Vector2(-90,-90)			# maybe make into a var and calculate an offset when set_shape is called

signal displayed_shape			# after shape has been displayed+paused
signal shrunk_shape				# after shape has finished shrinking
signal flew_away				# after the saved_tiles have been counted

# add sprites to this object in the shape they are meant to represent
# shape_array for bo3 is [3,1,1,1] which comes from ShapeDatabase
# shape_array is a width-prefixed 1D array which represents a 2D swipe
func set_shape(shape_array, tile_type = G.TYPE_DOG):
    var width = int(shape_array[0]) # is a float otherwise.. why??
    var num = 0					# how far along 1D array are we?
    var loc = Vector2(0,0)		# where individual sprites will be shown
    var total_tiles = 0			# so we can calcualte bonus required based on tile count
    # Loop through the bits of array after width
    for i in range(1, shape_array.size()):
        num = i - 1   # i starts at 1 due to width at position 0
        var bit = shape_array[i]
        if bit == 1:
            total_tiles = total_tiles + 1
            # x and y are determined by how far along 1D array we are
            var x = num % width
            var y = num / width
            loc = Vector2(x,y)			# where to put new sprite
            var sprite = Sprite2D.new()
            sprite.set_script(sprite_script)
            sprite.set_tile_type(tile_type)
            sprite.set_position(Helpers.slot_to_pixels(loc))
            add_child(sprite)
            _updateDimensions(loc)		# know how big swipe is
    return total_tiles			# So we can eventually tell the level bonus, based on number of required tiles

func set_text_word(word):
    $SpinnerLabel.text = word

func _updateDimensions(loc) :
    if(loc.x > self.dimensions.x):
        dimensions.x = loc.x
    if(loc.y > self.dimensions.y):
        dimensions.y = loc.y


func move_shape_left(pixels_to_slide, duration):
    var go_to_loc = self.get_position()                    # determine where we are now
    go_to_loc = go_to_loc - Vector2(pixels_to_slide,0)     # slide to left by removing positive number from x
    var effect = create_tween()
    effect.set_trans(Tween.TRANS_LINEAR)
    effect.set_ease(Tween.EASE_IN_OUT)
    effect.tween_property(self, "position", go_to_loc, duration)

# once shape has been shown for requirements, we need to shrink it
# and put it in a location, so this function accepts a Vector2
# as the destination.   Plus when shapes are swiped, this
# same function is used to tell the swipe where to go if it
# matches required shape
func shrink_shape(go_to_loc, duration, ratio = G.REQ_SHAPE_SHRINK_FACTOR, boost_spinner: bool = false):
    var effect = create_tween()
    effect.set_parallel(true)  # Allow multiple properties to tween simultaneously
    effect.finished.connect(_on_shrunk_shape)
    effect.set_trans(Tween.TRANS_QUAD)
    effect.set_ease(Tween.EASE_OUT)
    effect.tween_property(self, "scale", Vector2(ratio, ratio), duration)
    effect.set_trans(Tween.TRANS_LINEAR)
    effect.set_ease(Tween.EASE_IN_OUT)
    effect.tween_property(self, "position", go_to_loc, duration)
    if boost_spinner:
        var b = G.REQ_SPINNER_HUD_BOOST
        # Counter-shrink the spinner via font_size override AND scale.
        # The parent Node2D shrinks to `ratio` (e.g. 0.4); we want digits
        # readable in the corner without making the icon big. Boosting font
        # size scales the rendered glyphs without depending on Control->
        # Node2D scale composition (which produced unreadable output in Godot 4).
        var base_font_size = 192   # matches SpinnerLableFont.tres
        var boosted_font_size = int(base_font_size * b)
        self.spinner.add_theme_font_size_override("font_size", boosted_font_size)
        _position_spinner_south()
        print("HUD spinner boost: font_size=", boosted_font_size)

# Place the SpinnerLabel directly below the shape's bounding box, horizontally
# centered on the shape. Local coords — parent's HUD shrink applies on top.
# Used only in HUD mode (boost_spinner=true) so the digit doesn't overlap the
# icon column for vertical or square shapes (#110).
func _position_spinner_south():
    var slot_size = G.Game_slot_size()
    var center_slot = Vector2(self.dimensions.x / 2.0, self.dimensions.y)
    var anchor = Helpers.slot_to_pixels(center_slot, true)  # fractional x ok
    var rect_w = slot_size * 3.0
    var rect_h = slot_size * 2.0
    self.spinner.size = Vector2(rect_w, rect_h)
    self.spinner.position = Vector2(anchor.x - rect_w / 2.0, anchor.y + slot_size / 2.0)
    self.spinner.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    self.spinner.vertical_alignment = VERTICAL_ALIGNMENT_TOP

# TODO: make it random
func fly_away_randomly(duration):
    print("first tween starting")
    var go_to_loc = Helpers.slot_to_pixels(Vector2(4,10))
    var effect = create_tween()
    effect.set_parallel(true)  # Allow multiple properties to tween simultaneously
    effect.finished.connect(_on_come_back_to_location)
    effect.tween_property(self, 'scale', Vector2(5, 5), duration).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
    effect.tween_property(self, 'position', go_to_loc, duration).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
    effect.tween_property(self, 'rotation', 6, duration).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT_IN)
    effect.tween_property(self, 'modulate:a', 0, duration).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

##################################################
#
#   The idea here is the saved tiles can be collected somewhere and then help user win level.
#   Maybe I can just log a number instead of showing the swipes on the side
#
func _on_come_back_to_location():
    print("new tween starting")
    # Scale by G.ofaster like fly_away_randomly does — without this the
    # come-back tween was always 0.9s real time, regardless of testing speed,
    # which gated win detection (since this tween's `flew_away` signal is
    # what triggers the saved-tiles win check for non-required swipes).
    var duration = 0.9 * G.ofaster
    var go_to_loc = Helpers.slot_to_pixels(Vector2(4,10)) # was this but it was moved to GameHud and I don't know how to access gamehud from here  HUD.get_node('SavedTileCount').get_global_position()
    var effect = create_tween()
    effect.set_parallel(true)  # Allow multiple properties to tween simultaneously
    effect.finished.connect(_on_flew_away)
    effect.tween_property(self, 'scale', Vector2(0.02, 0.02), duration).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
    effect.tween_property(self, 'position', go_to_loc, duration).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
    effect.tween_property(self, 'rotation', 6, duration).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
    effect.tween_property(self, 'modulate:a', 1, duration).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

# swipe need not exist after it has flown away
func _on_flew_away():
    queue_free()	# cannot get them to act right so just kill them and don't save them
    emit_signal("flew_away")

# After shape has been shrunk
func _on_shrunk_shape():
    # call back to StarRequirements
    emit_signal("shrunk_shape")

# `display_quantity()` is only used when showing the user what
# shapes are required to win the level.  Add the number to the
# shape and spin it up so user knows
# how many of these shapes are required
func display_quantity(quantity):
    # once the spinner is done, we want it to tell us
    spinner.connect("qty_reached", _displayed_quantity)
    print("remove set_position because .tscn position works well enough")
#    spinner.set_position(self.numberic_offset_pixels)	# hardcoded until I can figure out positioning
    spinner.show()					# just in case
    spinner.set_delay(tick_delay)
    spinner.set_target(quantity)	# tell spinner where to stop
    spinner.start_tick_from(1)		# calls back to _displayed_quantity when finished

# `display_quantity_quickly()` is only used when showing the user what
# tiles are required to win the level.   Do it quick by starting from required number
func display_quantity_quickly(quantity):
    # once the spinner is done, we want it to tell us
    spinner.connect("qty_reached", _displayed_quantity)
    print("remove set_position because .tscn position works well enough")
#    spinner.set_position(self.numberic_offset_pixels)	# hardcoded until I can figure out positioning
    spinner.show()					# just in case
    spinner.set_delay(tick_delay)
    spinner.set_target(quantity)	# tell spinner where to stop
    spinner.start_tick_from(quantity)		# calls back to _displayed_quantity when finished

# call back to StarRequirements that this particular shape
# has finished displaying its number (and now can be shrunk
# out of the way for game play
func _displayed_quantity():
    # set up the timer which we will use to pause the action
    # after the shape has counted up to its target
    pauser.connect("timeout", dramatically_paused_after_display)
    pauser.set_wait_time(pause_time)
    pauser.set_one_shot(true)
    pauser.start()

func dramatically_paused_after_display():
    print("shape paused after display")
    emit_signal("displayed_shape")
    VisibleSwipeOverlay.draw_this_swipe([])		# remove the swipe
