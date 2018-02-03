extends Node2D

# from https://godotengine.org/qa/3829/how-to-draw-a-line-in-2d?show=3837#a3837
var draw_slot_list = []
var swipe_color

func _ready():
    set_process(true)
    draw_slot_list = []

func set_swipe_color(color):
    swipe_color = color

func draw_this_swipe(swipe, color = Color(1.0, 1.0, 0.5, 1.0)):
    draw_slot_list = swipe
    self.swipe_color = color

func _process(delta):
    update()

func _draw():
    if draw_slot_list != []:
        var draw_list = []
        for slot in draw_slot_list:
            draw_list.append(Helpers.slot_to_pixels(slot))
        draw_list.append(get_global_mouse_pos())	# make the swipe point to mouse (eventually, finger)
        var temp_draw_list = []
        for ob in draw_list:
            temp_draw_list.append(ob)
            if temp_draw_list != []:
                if temp_draw_list != draw_list:
                    draw_line(temp_draw_list[temp_draw_list.size()-1], draw_list[temp_draw_list.size()], self.swipe_color, 3)
