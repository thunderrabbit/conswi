#    Copyright (C) 2018  Rob Nugen
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

extends Node2D

var game_scene
var _todo_after_level
var _info_for_star_calc
export var swipe_lose_delay = 0.5
export var lose_points_per_swipe = 5
export var points_per_tile = 25

#######################################################
#
#   So  when finished, we know who we're gonna call
func set_game_scene(my_game_scene):
    game_scene = my_game_scene

func _ready():
    # Called every time the node is added to the scene.
    # Initialization here
    pass

#######################################################
#
#  	Public so it can be called by Game.gd
func show_stuff_after_level(info_for_star_calculation):
    self._info_for_star_calc = info_for_star_calculation
    self._decide_what_to_show()
    self._show_stuff_after_level()

#######################################################
#
#  	This will determine what to display, and in what order
func _decide_what_to_show():
    self._todo_after_level = []
    if self._info_for_star_calc['reason'] == G.LEVEL_WIN:
        self._PlanToDisplayBonus()		# put score on screen so we can edit it
        self._PlanToReduceSwipes()		# these three can be in any order
        self._PlanToReduceTiles()		# these three can be in any order (this one blacks out the tiles)
        self._PlanToAddTimeRemain()		# these three can be in any order
        self._PlanToDisplayStars()		# add stars below score (or above) or whatever, but should be last
        self._PlanToRemovePanel()		# remove panel from screen after a delay
    else:
        # this will black out the tiles, but *not* show score because score will not be there
        self._PlanToReduceTiles()

func _PlanToDisplayBonus():
    self._todo_after_level.push_back(G.STAR_DISPLAY_BONUS)

func _PlanToReduceSwipes():
    self._todo_after_level.push_back(G.STAR_REDUCE_SWIPES)

func _PlanToReduceTiles():
    self._todo_after_level.push_back(G.STAR_REDUCE_TILES)

func _PlanToAddTimeRemain():
    self._todo_after_level.push_back(G.STAR_ADD_TIME_REMAIN)

func _PlanToDisplayStars():
    self._todo_after_level.push_back(G.STAR_DISPLAY_STARS)

func _PlanToRemovePanel():
    self._todo_after_level.push_back(G.STAR_REMOVE_PANEL)

func _pause_before_show_stuff():
    var timer = $extra_pauser
    timer.connect("timeout",self,"_show_stuff_after_level")
    timer.set_wait_time(0.5)
    timer.start()

func _show_stuff_after_level():
    if not self._todo_after_level.size():
        self._on_last_star_displayed()	# fake emit
    else:
        var do_this_next = self._todo_after_level.pop_front()
        match do_this_next:
            G.STAR_DISPLAY_BONUS:
                self._display_bonus()
            G.STAR_REDUCE_SWIPES:
                self._reduce_swipes()
            G.STAR_REDUCE_TILES:
                self._reduce_tiles()
            G.STAR_ADD_TIME_REMAIN:
                self._add_time_remain()
            G.STAR_DISPLAY_STARS:
                self._display_stars()
            G.STAR_REMOVE_PANEL:
                self._remove_panel()

func _display_bonus():
    print("Display Bonus")
    $BonusPanel.show()
    var points = get_node("BonusPanel/BonusPoints")
    points.connect("qty_reached",self,"_pause_before_show_stuff")
    points.set_delay(0.05)
    var bonus_target = self._info_for_star_calc['num_tiles'] * self.points_per_tile
    points.set_target(bonus_target)	# tell spinner where to stop
    points.set_increment(floor(bonus_target * 0.05))	# take twenty steps to count
    points.start_tick_from(0)		# Start from 0 so null requirements level can be won.  Calls back to _displayed_quantity when finished 

func _reduce_swipes():
    print("Reduce Swipes")
    var points = get_node("BonusPanel/BonusPoints")
    var bonus_reduction = self._info_for_star_calc['waste_swipes'] * self.lose_points_per_swipe
    print("lose ", bonus_reduction, " points")
    points.set_delay(self.swipe_lose_delay)
    points.set_target_decrease(bonus_reduction)
    points.set_increment(self.lose_points_per_swipe)

    var wasted = HUD.get_node('WastedSwipeCount')
    wasted.set_delay(self.swipe_lose_delay)
    wasted.set_target(0)
    wasted.set_increment(1)
    wasted.start_tick()
    points.start_tick()

#####################################################
#
#  The plan is to always call this one, which will
#  display the score reduction due to remaining tiles and
#  have the bonus (spaghetti) side effect of telling
#  the tiles to remove themselves, one at a time.
#  If the score is not displayed, it will just remove tiles.
#
#  I am putting the code here to hopefully keep it simple
#  to keep the score reduction synced with tile removal
func _reduce_tiles():
    print("Reduce Tiles")
    self._show_stuff_after_level()  # simulate calling after animation complete

func _add_time_remain():
    print("Add Time Remain")
    self._show_stuff_after_level()  # simulate calling after animation complete

###
# not really thought out, but this will be called if G.STAR_DISPLAY_STARS is in self._todo_after_level
func _display_stars():
    var num_stars = _calculate_stars_for_level()
    for i in range(1,num_stars):
        # instantiate Tile of type TYPE
        # if this is last star, tell it to emit _on_last_star_displayed() callback when finished flying
        # fly it into place
        pass
    self._show_stuff_after_level()  # simulate calling after animation complete

#######################################################
#
#  	This will be private to the GD star_display.gd
func _calculate_stars_for_level():
    var existing_sprites = get_tree().get_nodes_in_group("players")
    var num_stars = randi()%3+1
    print("remaining pieces: ", existing_sprites.size())
    Savior.save_num_stars(G.TYPE_DOG, self._info_for_star_calc['level'], num_stars)
    return num_stars

func _remove_panel():
    print("Remove Panel")
    $BonusPanel.hide()
    self._show_stuff_after_level()  # simulate calling after animation complete

func _on_last_star_displayed():
    self.game_scene._on_level_over_stars_displayed()		# fake signal emitted by star_display.gd
