#    Copyright (C) 2021  Rob Nugen
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.

#####################################################################################
#
#   This code is probably too fat, but I don't know what makes sense to split out,
#   nor how to do it.
#
#####################################################################################

extends Node2D

# level zero allows for quickly testing swipe functionality
const always_play_level_zero = false
export var allow_easy_win = false

const GameHUD = preload("res://GameHUD.gd")

# gravity is what pulls the piece down slowly
var GRAVITY_TIMEOUT = 1 / G.ofaster     # fake constant that will change with level
var GRAVITY_FACTOR = 1 / G.ofaster		# how much slower to make gravity   (normally 1, but larger = slower for testing)
const MIN_TIME  = 0.07		# wait at least this long between processing inputs
const MIN_DROP_MODE_TIME = 0.004   # wait this long between move-down when in drop_mode
# mganetism pulls the pieces down quickly after swipes have erased pieces below them
const MAGNETISM_TIME = 0.2504

var current_level	= null	# will hold level definition
var level_over_reason = 0	# remember why we lost so we can slowly end the level, telling each overlay why we lost
var total_swipes_required_for_three_stars # remember how many swipes were needed for 3 stars
var level_num = 0			# will hold integer of level number
var elapsed_time = 10		# pretend it has been 10 seconds so input can definitely be processed upon start
var time_label				# will display time remain

var input_x_direction	# -1 = left; 0 = stay; 1 = right
var input_y_direction	# -1 = down; 0 = stay; 1 = up, but not implemented
var drop_mode = false   # true = drop the player
var gravity_called = false # true = move down 1 unit via gravity

var player_position			# Vector2 of slot player is in
var player					# Two (2) tiles: (player and shadow)
var game_hud

func _ready():
    self.game_hud = GameHUD.new()			# Buttons pre/post level
    # game_hud is kinda like a HUD but for game, not app
    self.game_hud.addHUDtoGame(self)
    add_child(self.game_hud)

    $GameSwipeDetector.Game = self

    Helpers.game_scene = self		# so Players know where to appear
    time_label = get_node("LevelTimer/LevelTimerLabel")
    stop_level_timer()

    # tell the Magnetism timer to call Helpers.magnetism_called (every MAGNETISM_TIME seconds)
    get_node("Magnetism").connect("timeout", get_node("/root/Helpers"), "magnetism_called", [])



    # TODO: add START button overlay
    # which will trigger this call:
    requested_play_level(Helpers.requested_level)

func requested_replay_level():
    requested_play_level(Helpers.requested_level)

func requested_next_level():
    Helpers.requested_level = Helpers.requested_level + 1
    requested_play_level(Helpers.requested_level)

func requested_play_level(level):
    game_hud.hide_labels()   # removes score from center of screen
    Helpers.clear_game_board()
    start_level(level)

func start_level(level_num):
    set_process(false)		# not sure that this actually helps
    grok_input(false)		# don't allow keyboard input during display of requirements
    self.level_num = level_num
    if always_play_level_zero:
        self.level_num = 0

    ### We send world through here but it is not sent into function start_level
    ##  It should at least be sent through like in _ready()
    #   requested_play_level(Helpers.requested_level)
    var levelGDScript = LevelDatabase.getExistingLevelGDScript(Helpers.requested_world, self.level_num)
    current_level = levelGDScript.new()		# load() gets a GDScript and new() instantiates it
    current_level.inject_world_and_level(Helpers.requested_world, self.level_num)   # determines number of tiles required to pass level
    current_level.pretty_print_level()    # defined in levels/NormalLevel.gd
    # now that we have loaded the level, we can tell the game how it wants us to run
    if self.allow_easy_win:
        current_level.debug_level = 1
        current_level.fill_level = true
    Helpers.grok_level(current_level)	# so we have level info available everywhere

    GRAVITY_TIMEOUT = current_level.gravity_timeout * self.GRAVITY_FACTOR

    # turn on buttons and show requirements for level
    game_hud.startLevel(current_level)

# turn input off for all children while display requirements / show cut scenes and the like
func grok_input(boolean):
    game_hud.buttons.grok_input(boolean)

func continue_start_level():
    self.total_swipes_required_for_three_stars = game_hud.star_reqs.count_star_requirements()  # so we know how many stars player gets at end of level
    $GameSwipeDetector.startLevel(current_level)

    SoundManager.play_bgm(LevelDatabase.getAnimalOfId(Helpers.requested_world) + " Game")
    # magnetism makes the nailed pieces fall (all pieces in board{})
    start_magnetism()

    # if level timer runs out the level is lost
    start_level_timer()

    # Fill the level halfway, if max_tiles_avail allows it
    if current_level.fill_level:
        fill_game_board()
    new_player()

func fill_game_board():
    # top corner is 0,0
    for across in range(Helpers.slots_across):
        for down in range(Helpers.slots_down/2, Helpers.slots_down):
            player_position = Vector2(across, down)

            player = Helpers.instantiatePlayer(player_position)
            if player != null:
                # lock player into position on Helpers.board{}
                nail_player()
            else:
                print("no more tiles available to fill game board!")

func new_player():
    # turn off drop mode
    drop_mode = false
    stop_moving()

    # select top center position
    player_position = Vector2(Helpers.slots_across/2, 0)
    # check game over
    if Helpers.board[Vector2(player_position.x, player_position.y)] != null:
        _level_over_prep()
        _gray_out_tiles()
        _show_stuff_after_level(G.LEVEL_NO_ROOM)

        return

    player = Helpers.instantiatePlayer(player_position)
    if player != null:
        # Now the player is movable by dragging or by gravity
        player.set_show_shadow(true)		# The shadow is at bottom, showing where tile will land
        player.set_draggable(true)			# now that the player is movable, we can drag it
        set_process(true)					# allows players to move
        grok_input(true)					# now we can give keyboard input
        start_gravity_timer()				# gravity needs to account for dragging somehow...
    else:
        print("no more tiles available to play game!")

#######################################################
#
#  Level is over, so we need to turn everything off
#
func _level_over_prep():
    grok_input(false)	# buttons.level_ended will turn on buttons again

    SoundManager.stop(LevelDatabase.getAnimalOfId(Helpers.requested_world) + " Game")
    stop_magnetism()
    stop_gravity_timer()
    stop_level_timer()

#######################################################
#
#   This is used when the level ended due to winning or losing, not cancelling
#
func _gray_out_tiles():
    # gray out block sprites if existing
    var existing_players = get_tree().get_nodes_in_group("players")
    for player in existing_players:
        player.level_ended()

#######################################################
#
#   This is used when the level cancelled by user
#   Could be used other times if you like to remove all the tiles from game
#
func _remove_all_tiles():
    var existing_players = get_tree().get_nodes_in_group("players")
    for player in existing_players:
        player.queue_free()

#######################################################
#
#    Need to collect all data to determine number of stars
#    Then send that info to be displayed asynchronously
func _show_stuff_after_level(reason):
    self.level_over_reason = reason		# not sure we need to remember this
    var collect_info_for_stars = {'reason':reason,
                                    'level':self.level_num,
                                    'num_tiles':$GameSwipeDetector.saved_tile_counter.num_tiles_all_types(),
                                    'safe_tiles':$GameSwipeDetector.saved_tiles,
                                    'correct_swipes':$GameSwipeDetector.correct_swipe_counter,
                                    'required_swipe_count':self.total_swipes_required_for_three_stars,
                                    'unlock_after_win':current_level.show_unlock_image_after_level_won,
                                }
    game_hud.stars_after_level.show_stuff_after_level(collect_info_for_stars)

#######################################################
#
#  	signal catcher
func _on_level_over_stars_displayed():
    self.level_over_stars_were_displayed()

func level_over_stars_were_displayed():
    self._remove_all_tiles()           # So level clear screen will show up on top (does not remove required swipes)
    game_hud.remove_all_requirements() # So level clear screen will show up on top
    self._level_over_display_buttons(self.level_over_reason)
    self._level_over_play_sound(self.level_over_reason)

func _level_over_display_buttons(reason):
    game_hud.buttons.level_ended(reason)

func _level_over_play_sound(reason):
    print("THIS IS WHY PLAY SOUND")
    if(reason == 1):
        SoundManager.play_se("Level Cleared")
    else:
        SoundManager.play_se("Level Failed")

func _process(delta):
    if gravity_called:
        input_y_direction = 1

    time_label.set_text(str(int(get_node("LevelTimer").get_time_left())))

    # if it has not been long enough, get out of here
    if (not drop_mode and elapsed_time < MIN_TIME) or (drop_mode and elapsed_time < MIN_DROP_MODE_TIME):
        elapsed_time += delta
        return

    # it has been long enough, so reset the timer before processing
    elapsed_time = 0

    if drop_mode:
        # turn on drop mode
        input_y_direction = 1

    # if we can move, move
    if check_movable(input_x_direction, 0):
        move_player(input_x_direction, 0)
    elif check_movable(0, input_y_direction):
        move_player(0, input_y_direction)
    else:
        if input_y_direction > 0:
            nail_player()
            new_player()

    # now that gravity has done its job, we can turn it off
    if gravity_called:
        input_y_direction = 0
        gravity_called = false

func check_movable(x, y):
    # x is side to side motion.  -1 = left   1 = right
    if x == -1 or x == 1:
        # check border
        if player_position.x + x >= Helpers.slots_across or player_position.x + x < 0:
            return false
        # check collision
        if Helpers.board[Vector2(player_position.x+x, player_position.y)] != null:
            return false
        return true
    # y is up down motion.  1 = down     -1 = up, but key is not connected
    if y == -1 or y == 1:
        # check border
        if player_position.y + y >= Helpers.slots_down or player_position.y + y < 0:
            return false
        if Helpers.board[Vector2(player_position.x, player_position.y+1)] != null:
            return false
        return true

func stop_moving():
    input_x_direction = 0
    input_y_direction = 0

func _gravity_says_its_time():
    gravity_called = true

func start_gravity_timer():
    var le_timer = get_node("GravityTimer")
    le_timer.set_wait_time(GRAVITY_TIMEOUT)
    le_timer.start()

func stop_gravity_timer():
    var le_timer = get_node("GravityTimer")
    le_timer.stop()

func start_level_timer():
    var le_timer = get_node("LevelTimer")
    le_timer.set_wait_time(current_level.time_limit_in_sec)
    le_timer.start()

func stop_level_timer():
    var le_timer = get_node("LevelTimer")
    le_timer.stop()

func start_magnetism():
    var magneto = get_node("Magnetism")
    magneto.set_wait_time(MAGNETISM_TIME)
    magneto.start()

func stop_magnetism():
    var magneto = get_node("Magnetism")
    magneto.stop()

# move player
func move_player(x, y):
    player_position.x += x
    player_position.y += y
    player.set_player_position(player_position)

# nail player to board
func nail_player():
    set_process(false)			# disable motion until next player is created
    set_process_input(false)	# ignore touches until next player is created
    stop_gravity_timer()
    player.nail_player()		# let player do what it needs when it's nailed

    # tell board{} where the player is
    Helpers.board[Vector2(player_position.x, player_position.y)] = player		## this is the piece so we can find it later

######################################
#
#  Called when user starts dragging a piece.
#  param piece is not needed except for function signature required by .connect function Fixes #26
func piece_being_dragged(piece):
    stop_gravity_timer()		# level timer still going

######################################
#
#  Called when user stops dragging a piece.
func piece_done_dragged(position):
    player_position = position
    start_gravity_timer()		# level timer still going

func _exit_tree():
    _level_over_prep()
    _remove_all_tiles()		# so they won't linger on screen

func _on_LevelWon():
    _level_over_prep()
    _gray_out_tiles()
    _show_stuff_after_level(G.LEVEL_WIN)

func _on_LevelTimer_timeout():
    _level_over_prep()
    _gray_out_tiles()
    _show_stuff_after_level(G.LEVEL_NO_TIME)
