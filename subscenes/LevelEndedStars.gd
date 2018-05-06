extends Node2D

var game_scene
var _todo_after_level
var _info_for_star_calc

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
	var points = get_node("BonusPoints")
	points.show()
	
	points.connect("qty_reached",self,"_show_stuff_after_level")
	points.show()					# just in case
	points.set_delay(0.001)
	points.set_target(self._info_for_star_calc['num_tiles'] * 25)	# tell spinner where to stop
	points.start_tick_from(1)		# calls back to _displayed_quantity when finished
#	points.set_value()
	pass

func _reduce_swipes():
	print("Reduce Swipes")
	self._show_stuff_after_level()  # simulate calling after animation complete
	pass

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
	pass

func _add_time_remain():
	print("Add Time Remain")
	self._show_stuff_after_level()  # simulate calling after animation complete
	pass

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
	get_node("BonusPoints").hide()
	self._show_stuff_after_level()  # simulate calling after animation complete
	pass

func _on_last_star_displayed():
	self.game_scene._on_level_over_stars_displayed()		# fake signal emitted by star_display.gd