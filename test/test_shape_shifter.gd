extends GutTest

# Regression coverage for the Godot 3 → 4 width-becomes-1.0 bug.
# Player swipe coords carry float Vector2 components; bitmap width was being
# serialized as "1.0" while ShapeDatabase keys are "1", so lookups silently
# missed and every required swipe took the fly_away_randomly branch.


func test_vertical3_swipe_recognized():
	# Three tiles in a column. Coords come from Helpers.pixels_to_slot which
	# returns Vector2 (float components) — same shape the live game produces.
	var coords = [Vector2(3.0, 11.0), Vector2(3.0, 10.0), Vector2(3.0, 9.0)]
	assert_eq(ShapeShifter.givenSwipe_lookupName(coords), "vertical3",
		"3-tile vertical swipe should be recognized as vertical3")


func test_horizontal3_swipe_recognized():
	var coords = [Vector2(1.0, 5.0), Vector2(2.0, 5.0), Vector2(3.0, 5.0)]
	assert_eq(ShapeShifter.givenSwipe_lookupName(coords), "horizontal3",
		"3-tile horizontal swipe should be recognized as horizontal3")


func test_bitmap_width_is_int_not_float():
	# Direct check on the bug: the width prefix in the bitmap must serialize
	# as int. If this fails, every named-swipe lookup will silently miss.
	var coords = [Vector2(3.0, 11.0), Vector2(3.0, 10.0), Vector2(3.0, 9.0)]
	var bitmap = ShapeShifter.getBitmapOfSwipeCoordinates(coords)
	assert_eq(typeof(bitmap[0]), TYPE_INT,
		"Bitmap width prefix should be int (got %s)" % typeof(bitmap[0]))
