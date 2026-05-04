extends GutTest

# Goal of this file (per issue #106): drive Dog World Level 1 to completion
# in an automated test, ending when the CLEAR! screen is visible.
#
# Status: scaffolding in place; full input-driven win is still pending.
# See test_can_win_dog_level_1() below for the playbook the win should follow.

const GAME_SCENE_PATH = "res://Game.tscn"


func before_each():
	# These autoload globals tell Game.tscn which level to start.
	Helpers.requested_world = G.TYPE_DOG
	Helpers.requested_level = 1


func test_game_scene_loads_and_starts_dog_level_1():
	# Integration smoke test: instantiate Game.tscn under the test runner,
	# add it to the tree, and verify Game._ready ran far enough to load
	# Dog Level 1 (which is what the test_can_win_dog_level_1 below builds on).
	var packed = load(GAME_SCENE_PATH)
	assert_not_null(packed, "Game.tscn should load")
	var game = packed.instantiate()
	assert_not_null(game, "Game scene should instantiate")
	add_child_autofree(game)
	# Let _ready run, level get loaded, requirements display kick off
	await wait_frames(3)
	assert_not_null(game.current_level,
		"Game._ready should populate current_level by frame 3")
	assert_eq(game.current_level.required_tiles, {"dog": 3},
		"Loaded level should be Dog Level 1 (require 3 dogs)")


func test_can_win_dog_level_1():
	# The full automated win, per issue #106 step list:
	#   1. drop three tiles straight down so they stack vertically
	#   2. swipe vertical3 across them
	#   3. assert the CLEAR! screen (level-ended buttons) becomes visible
	#
	# Constraint (per Rob): the test must only do what a human player could do.
	# That means input synthesis only — no calling game-logic helpers directly
	# (no Helpers.put_tile_at, no GameSwipeDetector.recognize_pattern, etc.).
	#
	# Implementation notes for whoever picks this up next:
	#   - Use Input.parse_input_event() to send "drop_down" action three times
	#     (three drops -> three dogs in a column). The action key is space (32).
	#   - Vertical3 swipe is mouse/touch-driven, not a keyboard action —
	#     synthesize InputEventMouseButton (pressed) at the top tile,
	#     InputEventMouseMotion down through the column, then
	#     InputEventMouseButton (released).
	#   - Coordinates must be in design viewport space (1242×2688). Compute tile
	#     positions from Helpers.slot_to_pixels(Vector2(col, row)).
	#   - Use await wait_seconds() between phases to let gravity / magnetism /
	#     tweens settle (game uses MAGNETISM_TIME = 0.2504s, MIN_TIME = 0.07s).
	#   - The level-clear screen lives in subscenes/LevelEndedButtons.tscn —
	#     check for it via get_tree().get_first_node_in_group(...) or by
	#     traversing game_hud.buttons after level_ended() fires.
	#   - Do NOT use Game.allow_easy_win = true; the test should pass through
	#     the same code path a real player exercises.
	pending("Full input-driven Dog Level 1 win not yet implemented — see issue #106")
