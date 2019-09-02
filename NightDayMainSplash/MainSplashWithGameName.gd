extends Sprite

var day_texture = preload("res://images/Folder_3/splashscreen_day@3x.png")
var night_texture = preload("res://images/Folder_3/splashscreen_night@3x.png")

func _ready():
	set_background()

# set_background keeps _ready() small
func set_background():
	var timeDict = OS.get_time();
	var hour = timeDict.hour;
	set_background_for_hour(hour)

# set_background_for_hour keeps things testable
func set_background_for_hour(var hour):
	if 6 <= hour && hour < 18:
		texture = day_texture
	else:
		texture = night_texture
