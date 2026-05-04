extends GutTest

# Drives Dog World Level 1 to completion via synthesized keyboard input
# for drops, and direct signal emission on the tile Area2D nodes for the
# vertical3 swipe (synthesized mouse events do not feed Godot 4's
# collision-picking subsystem). Per issue #106.

const GAME_SCENE_PATH = "res://Game.tscn"

# Game timings depend on G.ofaster (a const that's 0.01 by default for fast
# testing, 1.0 for normal play). Rather than calibrate fixed waits — which
# break when ofaster changes — these tests poll for state with a generous
# real-time cap.  Polling exits as soon as the condition is true, so the
# test stays fast at any ofaster value.
const POLL_MAX_SECS = 60.0


# Wait until check.call() returns true, or POLL_MAX_SECS real seconds elapse.
# Returns whether the condition was met before the deadline.
func _wait_until(check: Callable) -> bool:
	var deadline_ms = Time.get_ticks_msec() + int(POLL_MAX_SECS * 1000.0)
	while not check.call():
		if Time.get_ticks_msec() > deadline_ms:
			return false
		await wait_frames(1)
	return true


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
	# Poll until the level finishes setup (player spawns) — ofaster-independent.
	assert_true(await _wait_until(func(): return game.player != null),
		"First player should have spawned within %ss" % POLL_MAX_SECS)

	var col: int = int(Helpers.slots_across / 2)
	var bottom: int = int(Helpers.slots_down) - 1
	var sender = GutInputSender.new(Input)
	sender.set_auto_flush_input(true)
	# Drop one tile; wait for it to land before the next drop. Polling
	# Helpers.board for the expected slot avoids any reliance on ofaster.
	for row in [bottom, bottom - 1, bottom - 2]:
		sender.action_down("drop_down").wait("1f").action_up("drop_down")
		assert_true(await _wait_until(func(): return Helpers.board[Vector2(col, row)] != null),
			"Tile expected to land at column %d row %d within %ss" % [col, row, POLL_MAX_SECS])


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
	# Poll for player spawn (independent of ofaster).
	assert_true(await _wait_until(func(): return game.player != null),
		"First player should have spawned within %ss" % POLL_MAX_SECS)

	# 1. Drop three tiles, polling between drops so we don't rely on ofaster timing.
	var col: int = int(Helpers.slots_across / 2)
	var bottom: int = int(Helpers.slots_down) - 1
	var top_pos := Vector2(col, bottom - 2)
	var mid_pos := Vector2(col, bottom - 1)
	var bot_pos := Vector2(col, bottom)
	var sender = GutInputSender.new(Input)
	sender.set_auto_flush_input(true)
	for pos in [bot_pos, mid_pos, top_pos]:
		sender.action_down("drop_down").wait("1f").action_up("drop_down")
		assert_true(await _wait_until(func(): return Helpers.board[pos] != null),
			"Tile expected to land at %s within %ss" % [pos, POLL_MAX_SECS])

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

	# 3. Poll for the CLEAR! screen. The level-end chain has phases that use
	# real-time timers (e.g. _display_bonus's 4s score spinner) plus phases
	# that scale with ofaster — polling handles both regardless of value.
	var level_ended: Node = null
	assert_true(await _wait_until(func():
		level_ended = _find_level_ended_buttons(game)
		return level_ended != null and level_ended.visible
	), "LevelEndedButtons should become visible (CLEAR! screen) within %ss" % POLL_MAX_SECS)


func test_can_win_dog_level_2():
	# Dog Level 2: 9 tiles total, needs 3 vertical3 swipes for 3 stars.
	# Same column-3 strategy as Level 1, repeated 3 times.
	Helpers.requested_level = 2
	var packed = load(GAME_SCENE_PATH)
	var game = packed.instantiate()
	add_child_autofree(game)
	assert_true(await _wait_until(func(): return game.player != null),
		"First player should have spawned within %ss" % POLL_MAX_SECS)

	var col: int = int(Helpers.slots_across / 2)
	var bottom: int = int(Helpers.slots_down) - 1
	var top_pos := Vector2(col, bottom - 2)
	var mid_pos := Vector2(col, bottom - 1)
	var bot_pos := Vector2(col, bottom)
	var sender = GutInputSender.new(Input)
	sender.set_auto_flush_input(true)

	for cycle in range(3):
		# Drop three tiles into column 3 (gravity stacks them at the bottom).
		for pos in [bot_pos, mid_pos, top_pos]:
			sender.action_down("drop_down").wait("1f").action_up("drop_down")
			assert_true(await _wait_until(func(): return Helpers.board[pos] != null),
				"Cycle %d: tile expected to land at %s within %ss" % [cycle, pos, POLL_MAX_SECS])

		# Vertical3 swipe via signal emission (same as Level 1).
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

		# Wait for swiped tiles to clear before next cycle's drops.
		if cycle < 2:
			assert_true(await _wait_until(func(): return Helpers.board[bot_pos] == null),
				"Cycle %d: tiles should clear after swipe within %ss" % [cycle, POLL_MAX_SECS])

	var level_ended: Node = null
	assert_true(await _wait_until(func():
		level_ended = _find_level_ended_buttons(game)
		return level_ended != null and level_ended.visible
	), "Dog Level 2: LevelEndedButtons should become visible within %ss" % POLL_MAX_SECS)


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
