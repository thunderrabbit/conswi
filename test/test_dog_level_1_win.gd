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
	# Drive Dog Level 1 to completion. Keyboard input is synthesized via
	# GutInputSender (real input pipeline). The vertical3 swipe is performed
	# by emitting the tile Area2D signals directly, since synthesized mouse
	# events do not feed Godot 4's collision-picking subsystem and therefore
	# never trigger Segment.gd's input_event signal handlers. Emitting these
	# signals exercises every game function a real swipe would, minus the
	# picking layer (which is engine code, not ours to test).
	var packed = load(GAME_SCENE_PATH)
	var game = packed.instantiate()
	add_child_autofree(game)
	await wait_seconds(2.0)
	assert_not_null(game.player,
		"First player should have spawned by now (continue_start_level fired)")

	# 1. Drop three tiles via keyboard input.
	var sender = GutInputSender.new(Input)
	sender.set_auto_flush_input(true)
	for i in range(3):
		sender.action_down("drop_down").wait("2f").action_up("drop_down").wait("0.4s")
	await wait_for_signal(sender.idle, 5)

	var col: int = int(Helpers.slots_across / 2)
	var bottom: int = int(Helpers.slots_down) - 1
	var top_pos := Vector2(col, bottom - 2)
	var mid_pos := Vector2(col, bottom - 1)
	var bot_pos := Vector2(col, bottom)
	for pos in [top_pos, mid_pos, bot_pos]:
		assert_not_null(Helpers.board[pos],
			"Tile expected at %s after drops" % pos)

	# 2. Vertical3 swipe — emit the same signals real picking would emit.
	# board[pos] holds a Player; the Segment with the swipe signals is .mytile.
	var top_seg = Helpers.board[top_pos].mytile
	var mid_seg = Helpers.board[mid_pos].mytile
	var bot_seg = Helpers.board[bot_pos].mytile
	top_seg.emit_signal("clicked", top_pos, top_seg.tile_type)
	await wait_frames(1)
	mid_seg.emit_signal("entered", mid_pos, mid_seg.tile_type)
	await wait_frames(1)
	bot_seg.emit_signal("entered", bot_pos, bot_seg.tile_type)
	await wait_frames(1)
	bot_seg.emit_signal("unclicked")

	# Wait for the full level-end chain. _display_bonus runs a real-time
	# 4-second score-spinner animation; _reduce_swipes/_reduce_tiles add more.
	# Only after all phases complete does the LevelEndedButtons get shown.
	await wait_seconds(12.0)

	# 3. Assert the CLEAR! screen (LevelEndedButtons) is visible.
	var level_ended: Node = _find_level_ended_buttons(game)
	assert_not_null(level_ended,
		"LevelEndedButtons should exist in the tree after the win")
	if level_ended:
		assert_true(level_ended.visible,
			"LevelEndedButtons should be visible (CLEAR! screen showing)")


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
