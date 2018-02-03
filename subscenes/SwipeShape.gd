extends Node2D

const sprite_script = preload("res://subscenes/TileSprite.gd")
onready var spinner = get_node("SpinnerLabel")
onready var pauser = Timer.new()

const tick_delay = 0.73			# pause between countup qty
const pause_time = tick_delay	# pause after countup quantity

signal displayed_shape			# after shape has been displayed+paused
signal shrunk_shape				# after shape has finished shrinking

# add sprites to this object in the shape they are meant to represent
# shape_array for bo3 is [3,1,1,1] which comes from ShapeDatabase
# shape_array is a width-prefixed 1D array which represents a 2D swipe
func set_shape(shape_array, tile_type = 1):
    var width = int(shape_array[0]) # is a float otherwise.. why??
    var num = 0					# how far along 1D array are we?
    var loc = Vector2(0,0)		# where the shape will be shown
    # Loop through the bits of array after width
    for i in range(1, shape_array.size()):
        num = i - 1   # i starts at 1 due to width at position 0
        var bit = shape_array[i]
        if bit == 1:
            # x and y are determined by how far along 1D array we are
            var x = num % width
            var y = num / width
            loc = Vector2(x,y)			# where to put new sprite
            var sprite = Sprite.new()
            sprite.set_script(sprite_script)
            sprite.set_tile_type(tile_type)
            sprite.set_pos(Helpers.slot_to_pixels(loc))
            add_child(sprite)

# once shape has been shown for requirements, we need to shrink it
# for now, they all go to same (0,0) but soon they need to go to 
# their own locations.  So this function will need to accept a Vector2
# as the destination.   Plus when shapes are swiped, I think this
# same function can be used to tell the swipe where to go if it
# matches required shape
func shrink_shape(go_to_loc):
	var ratio = 0.2
	var effect = get_node("Tween")
	effect.connect("tween_complete", self, "shrunk_shape")
	effect.interpolate_property(self, 'transform/scale',
			self.get_scale(), Vector2(ratio, ratio), 0.9,
			Tween.TRANS_QUAD, Tween.EASE_OUT)
	effect.interpolate_property(self, 'transform/pos',
			self.get_pos(), go_to_loc, 0.9,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	effect.start()

# TODO: make it random
func fly_away_randomly():
	var go_to_loc = Helpers.slot_to_pixels(Vector2(10,10))
	var effect = get_node("Tween")
	effect.connect("tween_complete", self, "flew_away")
	effect.interpolate_property(self, 'transform/scale',
			self.get_scale(), Vector2(5, 5), 0.9,
			Tween.TRANS_QUAD, Tween.EASE_OUT)
	effect.interpolate_property(self, 'transform/pos',
			self.get_pos(), go_to_loc, 0.9,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	effect.interpolate_property(self, 'transform/rot', 0, 600, 0.9, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	effect.interpolate_property(self, 'visibility/opacity',
			1, 0, 0.9,
			Tween.TRANS_QUAD, Tween.EASE_OUT)
	effect.start()

# swipe need not exist after it has flown away
func flew_away(obj, key):
	if key == 'transform/scale':	# (callback only once per tween)
		queue_free()

# After shape has been shrunk
func shrunk_shape(obj, key):
	# call back to LevelRequirements
	if key == 'transform/scale':	# (callback only once per tween)
		emit_signal("shrunk_shape")

# `display_quantity()` is only used when showing the user what
# shapes are required to win the level.  Add the number to the
# shape and spin it up so user knows
# how many of these shapes are required
func display_quantity(quantity):
	# once the spinner is done, we want it to tell us
	spinner.connect("qty_reached",self,"_displayed_quantity")
	spinner.set_pos(Vector2(90,90))	# hardcoded until I can figure out positioning
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
