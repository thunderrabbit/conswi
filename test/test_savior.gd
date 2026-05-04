extends GutTest

# Regression coverage for the Godot 3 → 4 read-returns-float bug.
# JSON.parse_string in Godot 4 returns numeric values as float, so a saved
# `3` came back as `3.0` and `str(3.0)` baked into filenames produced
# "dog_level_3.0star@3x.png" — file not found.


func test_read_num_stars_returns_int():
	Savior.save_num_stars(G.TYPE_DOG, 1, 3)
	var stars = Savior.read_num_stars(G.TYPE_DOG, 1)
	assert_eq(typeof(stars), TYPE_INT,
		"read_num_stars should return int, got %s" % typeof(stars))
	assert_eq(stars, 3, "Round-trip 3 stars should read back as 3")


func test_read_high_score_returns_int():
	Savior._write_value("test_score_field", 1234)
	var score = Savior._read_value("test_score_field")
	# _read_value returns whatever's stored (may be float after JSON round-trip),
	# but read_high_score wraps in int(). Verify the high-level API returns int.
	# This test exercises a real world+level too.
	Savior._write_if_larger(Savior._world_string(G.TYPE_DOG) + Savior._level_string(1) + "score", 9999)
	var read_back = Savior.read_high_score(G.TYPE_DOG, 1)
	assert_eq(typeof(read_back), TYPE_INT,
		"read_high_score should return int, got %s" % typeof(read_back))


func test_str_of_read_num_stars_has_no_decimal():
	# The actual symptom: building a filename from str(num_stars).
	# Dog Level 1 always earns 3 stars (one required swipe = 1/1 ratio),
	# so re-using (DOG, 1, 3) is the realistic round-trip — no fake levels.
	Savior.save_num_stars(G.TYPE_DOG, 1, 3)
	var stars = Savior.read_num_stars(G.TYPE_DOG, 1)
	assert_eq(str(stars), "3",
		"str() of read_num_stars must be '3' not '3.0' (filenames depend on this)")
