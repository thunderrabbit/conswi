extends Node2D

func _ready():
	var new_player = $Sement
	new_player.set_tile_type(G.TYPE_DOG)
	new_player.set_scale(Vector2(5,5))
	new_player.set_position(OS.get_window_size()/2)

	$Timer.set_wait_time(G.splashscreen_timeout)
	$Timer.start()

func _on_SplashScreen_Timer_timeout():
	SceneSwitcher.goto_scene("res://LevelSelect/LevelSelectScene.tscn")