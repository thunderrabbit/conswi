extends "res://subscenes/SwipeShape.gd"

var show_finger = false		# if true, we will show the finger swiping from first to last tile
var quantity = 0			# store quantity while finger is swiping

func swipe_finger():
	if self.show_finger:
		$Finger.set_visible(true)
		$Tween.connect("tween_completed", self, "finger_swiped")
		$Tween.interpolate_property($Finger, "position",
				Vector2(20,20),		# TODO do not hardcode this
				Vector2(200,20),    # TODO do not hardcode this
				1, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		$Tween.start()
		var swipe_array = [Vector2(2,6),Vector2(5,6)]
		VisibleSwipeOverlay.draw_this_swipe(swipe_array,TileDatabase.tiles[G.TYPE_DOG].ITEM_COLOR)
	else:
#		print("no finger")
		finger_swiped(null, null)			# usually do this; only show finger in first couple of levels

func display_quantity(quantity):
	self.quantity = quantity
	print("swipe finger before display quantity")
	swipe_finger()

func finger_swiped(obj, key):
	$Finger.set_visible(false)
	.display_quantity(self.quantity)