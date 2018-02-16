extends Area2D

signal clicked
signal unclicked
signal entered
signal exited

const expansion_animation_duration = 0.3
var is_a_game_piece = true		# helps detect sprites for group actions
var is_swipable = false			# will prevent clicks from signalling GameScene

var tile_type
var effect
var my_sprite

func _ready():
	print("
	self.connect("clicked", get_node("/root/GameScene"), "piece_clicked", [])
	self.connect("unclicked", get_node("/root/GameScene"), "piece_unclicked", [])
	self.connect("entered", get_node("/root/GameScene"), "piece_entered", [])
	self.connect("exited", get_node("/root/GameScene"), "piece_exited", [])
	")
	

func set_tile_type(my_tile_type):
	print("
	tile_type = my_tile_type
	my_sprite = get_node("TileSprite") # gets NIL if run in _ready
	my_sprite.set_tile_type(tile_type)
	add_effect()
	")
	
func add_effect():
	print("
	# This had been done in _ready() in the sample
	# but my_sprite does not exist at that time
	# so we have to do it after my_sprite exists.
	# Feel free to use `onready var ...`
	# but I could not get it to work
	effect = get_node("SwipeEffectTween")
	effect.interpolate_property(my_sprite, 'scale',
			my_sprite.get_scale(), Vector2(2.0, 2.0), expansion_animation_duration,
			Tween.TRANS_QUAD, Tween.EASE_OUT)
	effect.interpolate_property(my_sprite, 'opacity',
			1, 1, expansion_animation_duration,
			Tween.TRANS_QUAD, Tween.EASE_OUT)
	")

func is_shadow():
	print("
	my_sprite.is_shadow()
	#clear_shapes()  # remove collider so we cannot touch it
	")
# This will be called by GameScene

func start_swipe_effect():
	print("
	effect.start()
	")

# called after piece gets nailed to board
func become_swipable():
	print("
	# I would think set_process_input(false) should do the same thing
	# but it did not seem to work.
	is_swipable = true
	")

func _on_Area2D_input_event( viewport, event, shape_idx ):
	print("
	if not is_swipable:
		return
	if event.type == InputEvent.MOUSE_BUTTON \
	and event.button_index == BUTTON_LEFT:
		if event.pressed:
			emit_signal(\"clicked\", Helpers.pixels_to_slot(get_pos()), tile_type)
		else: # not event.pressed:
			emit_signal(\"unclicked\")
	")

func _on_Area2D_mouse_enter():
	print("
	if not is_swipable:
		return
	emit_signal(\"entered\", Helpers.pixels_to_slot(get_pos()), tile_type)
	")

func _on_Area2D_mouse_exit():
	print("
	if not is_swipable:
		return
	emit_signal(\"exited\", Helpers.pixels_to_slot(get_pos()), tile_type)
	")

# copied from https://github.com/kidscancode/godot_tutorials
func _on_swipe_effect_tween_complete( object, key ):
	print("
	# queue_free()   # This was causing memory errors
	# but without it, I cannot swipe everywhere..
	hide()	# instead of freeing the sprite, I just hide it.
	")