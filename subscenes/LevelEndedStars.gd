extends Node2D

var game_scene
var _todo_after_level

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
#  	This will be public to the GD star_display.gd
func show_stuff_after_level(info_for_star_calculation):
	self._decide_what_to_show(info_for_star_calculation)
	self._show_stuff_after_level()

func _show_stuff_after_level():
	print("This is what we will do")
	print(self._todo_after_level)

	self._on_last_star_displayed()	# fake emit

#######################################################
#
#  	This will determine what to display, and in what order
func _decide_what_to_show(info_for_star_calc):
	self._todo_after_level = []
	if info_for_star_calc['reason'] == G.LEVEL_WIN:
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


###
# not really thought out, but this will be called if G.STAR_DISPLAY_STARS is in self._todo_after_level
func _display_stars(info_for_star_calculation):
	var num_stars = _calculate_stars_for_level(info_for_star_calculation)
	for i in range(1,num_stars):
		# instantiate Tile of type TYPE
		# if this is last star, tell it to emit _on_last_star_displayed() callback when finished flying
		# fly it into place
		pass

#######################################################
#
#  	This will be private to the GD star_display.gd
func _calculate_stars_for_level(info_for_star_calculation):
	var existing_sprites = get_tree().get_nodes_in_group("players")
	var num_stars = randi()%3+1
	print("remaining pieces: ", existing_sprites.size())
	Savior.save_num_stars(G.TYPE_DOG, info_for_star_calculation['level'], num_stars)
	return num_stars

func _on_last_star_displayed():
	self.game_scene._on_level_over_stars_displayed()		# fake signal emitted by star_display.gd