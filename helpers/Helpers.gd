#    Copyright (C) 2020  Rob Nugen
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
#  This is kinda like Globals, but for functions, most of which deal with placing tiles
#
#####################################################################################

extends Node

const Player = preload("res://subscenes/Player.gd")

var game_scene			# so we know where Players should appear
var board = {}			# board of slots_across x slots_down

var queue_upcoming = []			# queue of upcoming pieces
var queue_length = 0			# number of pieces to show in the queue
var max_tiles_avail = 0			# number of tiles available,
                                # including queue and fill_board
var upcoming_tiles = []

# width and height of level board
var slots_across = 7         #  can be overridden by level data .width
var slots_down = 12          #  but setting values here so LaserGrid can be shown before game is loaded
var debug_level = 0

# requested_world will be set by WorldSelectScript
# WorldSelectScript should deal with world permissions
# WorldSelectScript should deal with world DNE
var requested_world = 0
var world_slide_position = 0 # to allow same position on return
# Will be set by LevelSelection scene
# LevelSelection scene will deal with level entry permissions
# GameScene will deal with level DNE
var requested_level = 52

func _ready():
    board = {}

# clear the visual board
func clear_game_board():
    # clear block sprites if existing
    var existing_players = get_tree().get_nodes_in_group("players")
    for player in existing_players:
        remove_child(player)

# called after groking the level, because then we know how big it is
# prepare the Dictionary board{}
func prepare_board_and_queue():
    board = {}
    for i in range(slots_across):
        for j in range(slots_down):
            board[Vector2(i, j)] = null

    # empty the queue else we have ghosts when level restarts
    queue_upcoming = []

func magnetism_called():
    for pos in board:
        var sprite = board[pos]
        if sprite != null:
            sprite.move_down_if_room()

# if swipes exist on board, the game can continue
func search_for_swipes():
    for pos in board:
        var sprite = board[pos]
        if sprite != null:
            # determine scnc (Same Color Neighbor Count)
            var scnc = self.count_same_color_neighbors(pos)  # how many neighbors are the same color?
            sprite.set_swipeable_neighbors(scnc)  # useless until Sprite shows this value

func count_same_color_neighbors(pos):
    # https://www.gamedev.net/forums/topic/516685-best-algorithm-to-find-adjacent-tiles/?tab=comments#comment-4359055
    var xOffsets = [ 0, 1, 0, -1]
    var yOffsets = [-1, 0, 1,  0]

    var my_tile_type = board[pos].tile_type
    var offset_pos = Vector2(-99,-99)
    var scnc = 0
    var i = 0
    while i < xOffsets.size():
        offset_pos = Vector2(pos.x + xOffsets[i], pos.y + yOffsets[i])
        if self.tile_exists_in_board(offset_pos):    # there is a tile in this offset
            if board[offset_pos].tile_type == my_tile_type:
                scnc = scnc + 1
        i = i + 1
    return scnc

# @param Vector2 pos position to check
# @return bool or null
#
# when searching for same color neighbors, the pos might be off the board
# so this makes sure the pos is on the board AND a tile exists at that position
func tile_exists_in_board(pos):
    if 0 <= pos.x and pos.x < slots_across:
      if 0 <= pos.y and pos.y < slots_down:
        return board[pos]
    return false

func queue_wo_fill():
    while queue_upcoming.size() < queue_length and \
            max_tiles_avail > 0:
        max_tiles_avail = max_tiles_avail - 1
        # new player will be a random of available tile types
        var new_tile_type_ordinal = TileDatabase.random_type(upcoming_tiles)

        # debug overwrites everything and just give same tile
        if self.debug_level == 1:
            new_tile_type_ordinal = 0

        var new_player = Player.new()

        # Tell player what type it is
        new_player.set_type(new_tile_type_ordinal)
        add_child(new_player)

        queue_upcoming.append(new_player)

    # Display queued pieces on top right
    var x = slots_across - queue_length
    for tile in queue_upcoming:
        tile.set_player_position(Vector2(x,0))
        x += 1


func queue_next():
    queue_wo_fill()
    var next_piece = queue_upcoming.front()
    if next_piece != null:
        queue_upcoming.pop_front()
    return next_piece

# grok_level is not well designed in that it probably should *not* grok
# values that are not used outside GameScene.
# I happened to notice that `min_swipe_len` is not here, but works just
# fine because it is only accessed in GameScene via current_level.min_swipe_len
# Similarly, I am going to leave `time_limit_in_sec` out of here
# because I think it will only be used in GameScene
func grok_level(level_info):
    slots_across = level_info.width
    slots_down = level_info.height
    queue_length = level_info.queue_len + 1 # +1 accounts for current player
    debug_level = level_info.debug_level
    max_tiles_avail = level_info.max_tiles_avail
    upcoming_tiles = level_info.tiles
    self.prepare_board_and_queue()

func instantiatePlayer(player_position):
    # queue_next returns null if max_tiles_available has been exceeded
    var new_player = queue_next()
    if new_player != null:
        # Move the player
        new_player.set_player_position(player_position)
        return new_player		# we had tiles available
    else:
        return null	# no more tiles available

func pixels_to_slot(pixels, debug=false):
    # do reverse thing as 3141d61c7e60ff18cfbf573b5879fa1e577edbfc
    return Vector2(ceil((pixels.x - G.Game_left_space()) / (G.Game_slot_size())),
                    ceil((pixels.y - G.Game_top_space()) / (G.Game_slot_size())))

# return a scalar so we can slide required swipes over the right amount
func width_to_pixels(width, factor):
    var stp = slot_to_pixels(Vector2(width,0))
    return stp.x * factor

# below, skip_assert allows fractional slots to work okay
func slot_to_pixels(slot, skip_assert=false):
    # do same thing as 3141d61c7e60ff18cfbf573b5879fa1e577edbfc
    var stpv2 = Vector2(floor(G.Game_left_space()+G.Game_slot_size()*(slot.x)),
                    floor(G.Game_top_space()+G.Game_slot_size()*(slot.y)))
    # make sure we know what tiles are being clicked
    var double_check = pixels_to_slot(stpv2)
    assert(skip_assert || slot == double_check)   # if this fails, then pixels_to_slot will misidentify which tile has been clicked
    return stpv2

# Used for starting position when showing level requirements
func offset_bottom_center_slot_in_pixels(offset):
    return slot_to_pixels(Vector2((slots_across-1) / 2, slots_down-1)-offset)

func offset_bottom_center_slot(offset):
    return Vector2((slots_across-1) / 2, slots_down-1)-offset

func steering_pad_pixels():
    return Vector2(G.LeftSpace()+(G.GameGridSlotSize() + G.SlotGapH())*(slots_across / 2),
                    G.TopSpace()+(G.GameGridSlotSize() + G.SlotGapV())*(slots_down))
