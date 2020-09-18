#    Copyright (C) 2020  Rob Nugen
#
#    SwipeWords are shown when players swipe swipes
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

var wordsFor3Tiles = ["ok"];
var wordsFor4Tiles = ["ok"];
var wordsFor5Tiles = ["okay","so-so","not bad"];
var wordsFor6Tiles = ["nice","clear","safe"];
var wordsFor7Tiles = ["rad", "far out", "groovy"];
var wordsFor8Tiles = ["sweet", "fresh", "cool"];
var wordsFor9Tiles = ["neat", "def", "lit"];
var wordsFor10Tiles = ["super", "tip top", "stellar"];
var wordsFor11Tiles = ["gnarly", "way out", "snarly"];
var wordsFor12Tiles = ["good", "fine", "tight"];
var wordsFor13Tiles = ["great", "grand", "chill"];
var wordsFor14Tiles = ["boss", "top dog", "fat cat"];
var wordsFor15Tiles = ["superb!", "wow!", "amazing!"];


var wordsForSwipes = {
    5:wordsFor5Tiles,
    6:wordsFor6Tiles,
    7:wordsFor7Tiles,
    8:wordsFor8Tiles,
    9:wordsFor9Tiles,
    10:wordsFor10Tiles,
    11:wordsFor11Tiles,
    12:wordsFor12Tiles,
    13:wordsFor13Tiles,
    14:wordsFor14Tiles,
    15:wordsFor15Tiles
}


func _ready():
    randomize()

func random_word(word_length):
    if word_length < 4:
       return ""
    if word_length > 15:  ## so we don't overrun the array
       word_length = 15
    var wordsForSwipe = wordsForSwipes[word_length]   # get array of possible words
    var random_word_num = (randi() % wordsForSwipe.size())
    return wordsForSwipe[random_word_num]
