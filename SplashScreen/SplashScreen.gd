extends Node2D

func _ready():
	$Timer.set_wait_time(Globals.splashscreen_timeout)
	$Timer.start()

func _on_SplashScreen_Timer_timeout():
	SceneSwitcher.goto_scene("res://Game.tscn")