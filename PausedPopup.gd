extends Popup

func _on_PauseButton_pressed():
	set_exclusive(true)
	popup()
	get_tree().set_pause(true)
	print("paused")

func _on_UnpauseButton_pressed():
	hide()
	get_tree().set_pause(false)
	print("unpaused")
