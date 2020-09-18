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

var wordsFor3Tiles = [];
var wordsFor4Tiles = [];
var wordsFor5Tiles = ["five"];
var wordsFor6Tiles = ["si1x","sihx","sifx","si5x"];
var wordsFor7Tiles = ["se1ven","s7even","seve5n","seven"];
var wordsFor8Tiles = ["ei1ght","eig6ht","eigh5t","eight"];
var wordsFor9Tiles = ["ni1ne","ni6ne","nine","nine"];
var wordsFor10Tiles = ["t1en","te6n","ten","t5en"];
var wordsFor11Tiles = ["e1leven","el6even","e5leven","eleven"];
var wordsFor12Tiles = ["t1welve","twe6lve","t5welve","twelve"];
var wordsFor13Tiles = ["t1hirteen","thirteen5","thirteen","thirteen"];
var wordsFor14Tiles = ["c1at","cat","cat","c5at"];
var wordsFor15Tiles = ["c1at","cat","cat","c5at"];
var wordsFor16Tiles = ["c1at","cat","cat","c5at"];


var wordsForSwipes = {
    5:wordsFor5Tiles,
    6:wordsFor6Tiles,
    7:wordsFor7Tiles,
    8:wordsFor8Tiles,
    9:wordsFor9Tiles
}


func _ready():
    randomize()

func random_word(word_length):
    if word_length < 5:
       return ""
    if word_length > 9:  ## so we don't overrun the array
       word_length = 9
    var wordsForSwipe = wordsForSwipes[word_length]   # get array of possible words
    var random_word_num = (randi() % wordsForSwipe.size())
    return wordsForSwipe[random_word_num]
