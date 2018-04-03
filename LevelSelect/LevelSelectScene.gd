extends Node2D

# These are basically the same names as in Globals.gd
# But I am not sure if those Globals are useful for GameScene,
# much less this scene.  I am just creating class vars
# here so it is clear that they are only used here.
# Feel free to arrange these buttons in a better way.

const SLOT_SIZE       = 140
var left_space        = 30
var top_space         = 30
var slot_gap          = 25
var slot_gap_h        = slot_gap
var slot_gap_v        = slot_gap
var buttons_across    = 3
var num_buttons       = 12

const LevelSelectButton = preload("LevelSelectButton.tscn")

func _ready():
    var button_loc = Vector2(0,0)
    for level in range(1,num_buttons+1):
        button_loc = level_to_pixels(level)
        var level_but = LevelSelectButton.instance()
        level_but.set_position(button_loc)
        level_but.set_level(level)
        level_but.set_size(Vector2(SLOT_SIZE,SLOT_SIZE))

        level_but.connect("pressed",self,"_on_Button_pressed",[level])
        add_child(level_but)

func level_to_pixels(level):
	# level-1 because we start with 1 above.  Otherwise gap appears in top left corner
    level = level - 1
    var slot = Vector2(level % buttons_across, level / buttons_across)
    return Vector2(left_space+(SLOT_SIZE + slot_gap_h)*(slot.x), 
                    top_space+(SLOT_SIZE + slot_gap_v)*(slot.y))

func _on_Button_pressed(level):
    Helpers.requested_level = level
    get_node("/root/SceneSwitcher").goto_scene("res://Game.tscn")
