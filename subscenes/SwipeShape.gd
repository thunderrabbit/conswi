extends Node2D

const sprite_script = preload("res://tiles/Segment.gd")
onready var spinner = get_node("SpinnerLabel")
onready var pauser = Timer.new()

var dimensions = Vector2(0,0)	# will tell the size of the shape
const tick_delay = 0.73			# pause between countup qty
const pause_time = tick_delay	# pause after countup quantity
const numberic_offset_pixels = Vector2(-90,-90)			# maybe make into a var and calculate an offset when set_shape is called

signal displayed_shape			# after shape has been displayed+paused
signal shrunk_shape				# after shape has finished shrinking
signal flew_away				# after the wasted swipe has vanished

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
            var sprite = Sprite.new()
            sprite.set_script(sprite_script)
            sprite.set_tile_type(tile_type)
            sprite.set_position(Helpers.slot_to_pixels(loc,false))		# change false to true to debug position
            add_child(sprite)
            _updateDimensions(loc)		# know how big swipe is
    return total_tiles			# So we can eventually tell the level bonus, based on number of required tiles

func _updateDimensions(loc) :
	if(loc.x > self.dimensions.x):
		dimensions.x = loc.x
	if(loc.y > self.dimensions.y):
		dimensions.y = loc.y

# once shape has been shown for requirements, we need to shrink it
# for now, they all go to same (0,0) but soon they need to go to 
# their own locations.  So this function will need to accept a Vector2
# as the destination.   Plus when shapes are swiped, I think this
# same function can be used to tell the swipe where to go if it
# matches required shape
func shrink_shape(go_to_loc, duration = 0.9):
	var ratio = 0.2
	var effect = get_node("Tween")
	effect.connect("tween_completed", self, "shrunk_shape")
	effect.interpolate_property(self, "scale",
			self.get_scale(), Vector2(ratio, ratio), duration,
			Tween.TRANS_QUAD, Tween.EASE_OUT)
	effect.interpolate_property(self, "position",
			self.get_position(), go_to_loc, duration,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	effect.start()

# TODO: make it random
func fly_away_randomly(duration = 0.9):
	print("first tween starting")
	var go_to_loc = Helpers.slot_to_pixels(Vector2(4,10))
	var effect = get_node("Tween")
	effect.connect("tween_completed", self, "come_back_to_location")
	effect.interpolate_property(self, 'scale', self.get_scale(), Vector2(5, 5), duration, Tween.TRANS_QUAD, Tween.EASE_OUT)
	effect.interpolate_property(self, 'position', self.get_position(), go_to_loc, duration,	Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	effect.interpolate_property(self, 'rotation', 0, 6, duration, Tween.TRANS_LINEAR, Tween.EASE_OUT_IN)
	effect.interpolate_property(self, 'opacity', 1, 0, duration, Tween.TRANS_QUAD, Tween.EASE_OUT)
	effect.start()

##################################################
#
#   The idea here is the wasted swipes can be collected somewhere and then count against the user.
#   Maybe I can just log a number instead of showing the swipes on the side
#
func come_back_to_location(obj, key):
	print("new tween starting")
	if key != ':scale':	# (callback only once per tween)
		return
	var duration = 0.9
	var go_to_loc = HUD.get_node('WastedSwipeCount').get_global_position()
	var effect = get_node("Tween")
	effect.connect("tween_completed", self, "flew_away")
	effect.interpolate_property(self, 'scale', self.get_scale(), Vector2(0.02, 0.02), duration, Tween.TRANS_QUAD, Tween.EASE_OUT)
	effect.interpolate_property(self, 'position', self.get_position(), go_to_loc, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	effect.interpolate_property(self, 'rotation', 0, 6, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	effect.interpolate_property(self, 'opacity', 0, 1, duration, Tween.TRANS_QUAD, Tween.EASE_OUT)
	effect.start()

# swipe need not exist after it has flown away
func flew_away(obj, key):
	if key == ':scale':	# (callback only once per tween)
		queue_free()	# cannot get them to act right so just kill them and don't save them
		emit_signal("flew_away")

# After shape has been shrunk
func shrunk_shape(obj, key):
	# call back to LevelRequirements
	if key == ':scale':	# (callback only once per tween)
		emit_signal("shrunk_shape")

# `display_quantity()` is only used when showing the user what
# shapes are required to win the level.  Add the number to the
# shape and spin it up so user knows
# how many of these shapes are required
func display_quantity(quantity):
	# once the spinner is done, we want it to tell us
	spinner.connect("qty_reached",self,"_displayed_quantity")
	spinner.set_position(self.numberic_offset_pixels)	# hardcoded until I can figure out positioning
	spinner.show()					# just in case
	spinner.set_delay(tick_delay)
	spinner.set_target(quantity)	# tell spinner where to stop
	spinner.start_tick_from(1)		# calls back to _displayed_quantity when finished

# call back to LevelRequirements that this particular shape 
# has finished displaying its number (and now can be shrunk
# out of the way for game play
func _displayed_quantity():
	# set up the timer which we will use to pause the action
	# after the shape has counted up to its target
	pauser.connect("timeout",self,"dramatically_paused_after_display")
	pauser.set_wait_time(pause_time)
	pauser.set_one_shot(true)
	add_child(pauser)			# so it gets processed()
	pauser.start()

func dramatically_paused_after_display():
	print("shape paused after display")
	emit_signal("displayed_shape")
