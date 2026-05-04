extends GutTest


func test_gut_runs_a_basic_assertion():
	assert_true(true, "GUT runs and assert_true(true) passes")


func test_gut_can_compare_dictionaries():
	assert_eq({"dog": 3}, {"dog": 3}, "GUT can compare equal dictionaries")
