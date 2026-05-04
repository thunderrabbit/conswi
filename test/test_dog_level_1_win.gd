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


func test_can_drop_three_tiles_via_keyboard():
	# What works: keyboard input through GutInputSender reaches SteeringPad's
	# _input(event), which sets game.drop_mode and ultimately drops tiles.
	# After 3 drops, three dog tiles should be stacked at the bottom of column 3.
	var packed = load(GAME_SCENE_PATH)
	var game = packed.instantiate()
	add_child_autofree(game)
	await wait_seconds(2.0)

	var sender = GutInputSender.new(Input)
	sender.set_auto_flush_input(true)
	for i in range(3):
		sender.action_down("drop_down").wait("2f").action_up("drop_down").wait("0.4s")
	await wait_for_signal(sender.idle, 5)

	var col: int = int(Helpers.slots_across / 2)
	var bottom: int = int(Helpers.slots_down) - 1
	for row in [bottom, bottom - 1, bottom - 2]:
		assert_not_null(Helpers.board[Vector2(col, row)],
			"Tile expected at column %d row %d after drops" % [col, row])


func test_can_win_dog_level_1():
	# What does NOT work yet: synthesized mouse events do not trigger the
	# Area2D collision picking that fires Segment.gd's piece_clicked /
	# piece_entered / piece_unclicked signals. Tried every combo I can think of:
	#   - Input.parse_input_event() via GutInputSender (default)
	#   - viewport.push_input() directly
	#   - With and without sender.set_auto_flush_input(true)
	#   - With and without sender.mouse_warp = true
	#   - With and without viewport.physics_object_picking = true
	#   - Headless and windowed
	#   - wait_frames vs await get_tree().physics_frame
	# In every run, "key drop down activated" prints (keyboard works), but
	# "swipe seg clicked" never prints (mouse picking does not fire).
	#
	# Suspected cause: in Godot 4, Area2D's input_event signal is fed by the
	# viewport's mouse-picking system, which uses the OS cursor's actual
	# position rather than positions carried in synthesized events. Both
	# Input.parse_input_event and viewport.push_input route the event through
	# the global input system but do not feed the picking subsystem with a
	# synthetic cursor position. Real mouse picking would require either an
	# OS-level cursor (xdotool / xvfb-run) or a code change in the game so
	# tiles also receive events via _input(event) instead of only via
	# Area2D.input_event.
	#
	# Path forward needs a decision (see #106 comment): refactor tile input,
	# use external OS automation, or accept signal-emission as the test path.
	pending("Synthesized mouse events do not trigger Area2D picking — see in-file comment and issue #106 for next-step options")


func _find_level_ended_buttons(root: Node) -> Node:
	# Walk the tree looking for a node named "LevelEndedButtons" or whose
	# script path contains that name.
	var stack: Array = [root]
	while not stack.is_empty():
		var node: Node = stack.pop_back()
		if node.name == "LevelEndedButtons":
			return node
		var script: Script = node.get_script()
		if script and "LevelEndedButtons" in script.resource_path:
			return node
		for child in node.get_children():
			stack.push_back(child)
	return null
