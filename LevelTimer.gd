extends Timer

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	start()
	pass

func _process(delta):
	$LevelTimerLabel.set_text(String(self.time_left))