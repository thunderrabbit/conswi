extends Container

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	print("hello from HUD Bottom Buttons")
	pass

func _on_BackButton_pressed():
	get_node("/root/SceneSwitcher").goto_scene("res://NightDayMainSplash/NightDayMainSplash.tscn")
	