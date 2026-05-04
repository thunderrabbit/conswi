extends GutTest

# Verifies that Dog World Level 1's level data still matches what the
# automated win test (test_dog_level_1_win.gd) is built against.
# If these assertions fail, the win test almost certainly needs updating too.

const LEVEL_1_PATH = "res://levels/DogWorld/normal_01.gd"


func test_dog_level_1_script_loads():
	var script = load(LEVEL_1_PATH)
	assert_not_null(script, "Dog Level 1 script should load from %s" % LEVEL_1_PATH)


func test_dog_level_1_requires_3_dogs_to_pass():
	var level = load(LEVEL_1_PATH).new()
	assert_eq(level.required_tiles, {"dog": 3},
		"Dog Level 1 should require exactly 3 dog tiles to pass")


func test_dog_level_1_three_stars_needs_one_vertical3():
	var level = load(LEVEL_1_PATH).new()
	assert_eq(level.star_requirements, {"vertical3": 1},
		"Dog Level 1 should award 3 stars for one vertical3 swipe")


func test_dog_level_1_only_provides_dog_tiles():
	var level = load(LEVEL_1_PATH).new()
	# tiles is a ratio dict; non-dog values should be 0
	assert_eq(level.tiles.get("dog", 0), 1, "dog tile ratio should be 1")
	for animal in ["cow", "bear", "panda"]:
		assert_eq(level.tiles.get(animal, 0), 0,
			"Dog Level 1 should provide 0 %s tiles" % animal)


func test_dog_level_1_max_three_tiles_available():
	var level = load(LEVEL_1_PATH).new()
	assert_eq(level.max_tiles_avail, 3,
		"Dog Level 1 only gives the player 3 tiles total")
