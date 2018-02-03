extends Label

var value = 0		# this is the current value
var target = 0		# if in spin mode, these is our destination
var tick_delay = 0.73	# how many seconds to wait between ticks when spinning
onready var tick_timer = Timer.new()

signal qty_reached

func _ready():
	tick_timer.connect("timeout",self,"_check_spin_qty")

func set_value(value):
	self.value = value
	set_text(String(value))

func set_target(target):
	self.target = target

func set_delay(delay):
	self.tick_delay = delay

func start_tick_from(start_value):
	set_value(start_value)
	tick_timer.set_wait_time(tick_delay)
	tick_timer.start()

func inc_value():
	set_value(value + 1)

func _check_spin_qty():
	if self.value < self.target:
		inc_value()
	if self.value == self.target:
		print("we reached the target of ", self.target)
		tick_timer.stop()
		emit_signal("qty_reached")
	else: 
		print(self.value, " is not yet at target of ", self.target)
