extends "res://subscenes/SwipeShape.gd"

var show_finger = false		# if true, we will show the finger swiping from first to last tile
var quantity = 0			# while finger is swiping, remembers how many of these swipes are needed so they can be displayed by parent class

func swipe_finger():
	if self.show_finger:
		$Finger.set_visible(true)
		$FingerTween.connect("tween_completed", self, "finger_swiped")
		$FingerTween.interpolate_property($Finger, "position",
				Vector2(20,20),		# TODO do not hardcode this
				Vector2(200,20),    # TODO do not hardcode this
				1,					# Duration of tween
				Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		$FingerTween.start()
		var swipe_array = [Helpers.offset_bottom_center_slot(dimensions),Helpers.offset_bottom_center_slot(Vector2(0,0))]
		VisibleSwipeOverlay.draw_this_swipe(swipe_array,TileDatabase.tiles[G.TYPE_DOG].ITEM_COLOR,false)	# false = do not add mouse pos to swipe
	else:
		finger_swiped(null, null)			# usually do this; only show finger in first couple of levels

# This display_quantity first displays the finger
func display_quantity(quantity):
	self.quantity = quantity
	print("swipe finger before display quantity")
	swipe_finger()

func finger_swiped(obj, key):
	$Finger.set_visible(false)
	# This is the parent class display_quantity which actually displays the quantity
	.display_quantity(self.quantity)