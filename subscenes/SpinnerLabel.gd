extends Label

var value = 0		# this is the current value
var target = 0		# if in spin mode, this is our destination
var tick_delay = 0.73	# how many seconds to wait between ticks when spinning
var increment = 1
onready var tick_timer = Timer.new()

signal qty_reached

func _ready():
	tick_timer.connect("timeout",self,"_check_spin_qty")
	add_child(tick_timer)  # so it gets processed()

func set_increment(increment):
	self.increment = abs(increment)

func set_value(value):
	self.value = value
	set_text(String(value))

func set_target(target):
	self.target = target

func set_target_increase(increase):
	self.target = self.value + increase

func set_target_decrease(decrease):
	self.target = self.value - decrease

func set_delay(delay):
	self.tick_delay = delay

func start_tick():
	tick_timer.set_wait_time(tick_delay)
	tick_timer.start()

func start_tick_from(start_value):
	set_value(start_value)
	self.start_tick()

func inc_value(increment = 1):
	set_value(value + increment)

func dec_value(increment = 1):
	set_value(value - increment)

func _check_spin_qty():
	if self.value + self.increment < self.target:
		inc_value(self.increment)
	elif self.value- self.increment > self.target:
		dec_value(self.increment)
	else:
		set_value(self.target)

	if self.value == self.target:
		tick_timer.stop()
		emit_signal("qty_reached")
	else: 
		print(self.value, " is not yet at target of ", self.target)
