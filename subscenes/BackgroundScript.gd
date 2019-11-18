#    Update the furthest back image in the game; the static background
#
#    Copyright (C) 2018  Rob Nugen
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
extends Node

var default_texture = preload("res://images/background@2x.png")

func _ready():
	$BackgroundSprite.texture = default_texture

func set_background(bg_num = G.TYPE_DOG):
	var my_type_string = TileDatabase.tiles[bg_num]["ITEM_NAME"]
	# background path example "res://images/world_skins/cow/cow background@3x.png"
	var background = String("res://images/world_skins/" +
							my_type_string + "/" + 
							my_type_string + " background@3x.png")
	$BackgroundSprite.set_texture(load(background))
	_set_bg_scale()

func _set_bg_scale():
	var viewportWidth = get_viewport().size.x
	var viewportHeight = get_viewport().size.y

	var wscale = viewportWidth / $BackgroundSprite.texture.get_size().x
	var hscale = viewportHeight / $BackgroundSprite.texture.get_size().y
	
	# Set same scale value horizontally/vertically to maintain aspect ratio
	# If however you don't want to maintain aspect ratio, simply set different
	# scale along x and y
	$BackgroundSprite.set_scale(Vector2(wscale, hscale))
