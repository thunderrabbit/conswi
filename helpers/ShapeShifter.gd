#    Copyright (C) 2020  Rob Nugen
#
#    Converts swipes to names of swipes
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

var bitmapNames = {}		# will be filled in automatically based on ShapeDatabase.ShapeDatabase

func _ready():
    # fill in bitmapNames so we can look up the name of a swipe given its coordinates
    for shapeName in ShapeDatabase.shapes:
        # get the Shape Array as a string to use as a dictionary key in bitmapNames
        var arr_as_str = String(ShapeDatabase.shapes[shapeName])
        # if it exists, then presumably there is an error in the ShapeDatabase
        # (or an error in belief that different swipes produce different arrays)
        if bitmapNames.has(arr_as_str):
            print("Alert! ", shapeName, " duplicates array ", arr_as_str, " already found in bitmapNames.")
            print("Make sure there are no repeated arrays in ShapeDatabase")
            get_tree().quit()    # kill the game because swipes do not work if there are duplicates
        bitmapNames[arr_as_str] = shapeName		# e.g. [1,1,1,1] = 'ta3'

func _getBitmapStringOfSwipeCoordinates(swipeCoordinates):
    # we need a String because arrays cannot be reliably used as Dictionary keys
    return String(getBitmapOfSwipeCoordinates(swipeCoordinates))

# private function which gets a string representing a swipe
# I am going on the unproven assumption that any different swipe shape
# (rotations are different shapes) will produce unique strings
func getBitmapOfSwipeCoordinates(swipeCoordinates):
    var swipeDimensions = getSwipeDimensions(swipeCoordinates)
    var bitmapArray = createBitmap(swipeDimensions,swipeCoordinates)
    return prepareBitmap(swipeDimensions,bitmapArray)

##  This only has to work for named swipes because it is only used to
##    determine where on the screen required swipes should be shown
func getWidthOfShapeName(shapeName):
    var array_of_named_swipe = ShapeDatabase.shapes[shapeName]
    return array_of_named_swipe[0]

func getBitmapOfSwipeName(swipe_name):
    return ShapeDatabase.shapes[swipe_name]

# This is basically used to create the Library.
# We do a swipe (in debug mode) and this will print an array representing the swipe
func givenSwipe_showArray(swipeCoordinates):
    var bitmapString = _getBitmapStringOfSwipeCoordinates(swipeCoordinates)
    printBitmap(bitmapString)

# This will look for the name of the swipe shape given a swipe
# It will be used by GameScene to ensure the user has done the required swipes to pass a given level
func givenSwipe_lookupName(swipeCoordinates):
    var bitmapString = _getBitmapStringOfSwipeCoordinates(swipeCoordinates)
    var nameOfSwipe = null
    if bitmapNames.has(bitmapString):
        nameOfSwipe = bitmapNames[bitmapString]
        print(nameOfSwipe)
    else:
        print("shape not in library:")
        print(bitmapString)
    return nameOfSwipe

# given coordinates of a swipe, return its width, height, top left, bottom right
func getSwipeDimensions(swipeCoordinates):
    # start somewhere and call it extreme
    var leftmost_x = swipeCoordinates[0].x
    var rightmost_x = swipeCoordinates[0].x
    var upmost_y = swipeCoordinates[0].y
    var downmost_y = swipeCoordinates[0].y

    for coord in swipeCoordinates:
        leftmost_x = min(leftmost_x,coord.x)
        rightmost_x = max(rightmost_x,coord.x)
        upmost_y = min(upmost_y,coord.y)
        downmost_y = max(downmost_y, coord.y)

    # see how wide/tall the swipe is
    var width = (rightmost_x - leftmost_x) + 1
    var height = (downmost_y - upmost_y) + 1

    return {'topleft': Vector2(leftmost_x,upmost_y),
            'botright': Vector2(rightmost_x, downmost_y),
            'width': width,
            'height': height}

func createBitmap(swipeDimensions,swipeCoordinates):
    var bitmapArray = []
    var width = swipeDimensions.width			# int
    var height = swipeDimensions.height			# int
    var upperleft = swipeDimensions.topleft		# Vector2
    var tc = Vector2(0,0)	# translated_coordinates

    # fill array with zeroes
    for i in range(width * height):
        bitmapArray.append(0)

    for coord in swipeCoordinates:
        # translate coordinates to upper left is (0,0)
        tc = coord - upperleft
        bitmapArray[tc.x + tc.y * width] = 1
    return bitmapArray

func prepareBitmap(swipeDimensions,bitmapArray):
    # arrays are sent by reference, so this actually changes bitmapArray
    bitmapArray.push_front(swipeDimensions.width)
    return bitmapArray

func printBitmap(theBitmap):
    print(theBitmap)
