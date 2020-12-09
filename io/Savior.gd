#    Copyright (C) 2020  Rob Nugen
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

const TEXT_SAVE_PATH = "user://save_game_data.dat"
const ENCRYPTED_PATH = "user://save_game_data.bin"

var saved_game = File.new() 	# file which will allow us to see what was written
var encrypted_game = File.new() # file which will actually read the data
var password					# used to encrypt data

var save_dict = {} 				# variable to store data in memory


####################################################
#
#	On first run, create local files to save the data
#
#   On subsequent runs, load previously saved data
func _ready():
    self.password = OS.get_unique_id()	# TODO fix BUG: Only works on Android and iOS!!!!
    self._initialize_data()				# Don't need to do this if local files exist
    self._create_files_prn()			# will save files if they do not exist
    self.read_savegame()				# will read default at first, then updated value if anything has been saved

####################################################
#
#   Create local files if necessary
func _create_files_prn():
    if not saved_game.file_exists(TEXT_SAVE_PATH):
        self._save_data_encrypted_prn(TEXT_SAVE_PATH,false)		# false = no encryption
    if not encrypted_game.file_exists(ENCRYPTED_PATH):
        self._save_data_encrypted_prn(ENCRYPTED_PATH)

####################################################
#
#   Save data in one of two formats:
#      secure binary format (default)
#      debug-friendly text format
func _save_data_encrypted_prn(filename, encrypt = true):
    var f = File.new()
    if(encrypt):
        f.open_encrypted_with_pass(filename, File.WRITE, self.password)
    else:
        f.open(filename, File.WRITE)
    f.store_string(to_json(self.save_dict))
    f.close()

####################################################
#
#   Save both visible and encrypted files
func _save_both_files():
    print("saving both visible and encrypted data files")
    print(self.save_dict)
    self._save_data_encrypted_prn(TEXT_SAVE_PATH,false)		# false = no encryption
    self._save_data_encrypted_prn(ENCRYPTED_PATH)

####################################################
#
#   "low" level function just saves value and writes to disk
func _write_value(field, value):
    self.save_dict[field] = value;		# Add value to dictionary
    self._save_both_files()				# Save data to disk

####################################################
#
#   "low" level function just returns value
func _read_value(field):

    if(self.save_dict != null && self.save_dict.has(field)):
        return self.save_dict[field]
    else:
        return 0

####################################################
#
#   "mid" level function writes value if it is larger
#    than previously saved value
func _write_if_larger(field, value):
    if(value > int(self._read_value(field))):
        _write_value(field, value)

####################################################
#
#   "high" level function saves high score
#    This should be used within rest of game
func save_high_score(world,level, score):
    var world_string = self._world_string(world)
    var level_string = self._level_string(level)
    self._write_if_larger(world_string + level_string + "score",score)

####################################################
#
#   "high" level function saves num_stars
#    This should be used within rest of game
func save_num_stars(world,level, stars):
    var world_string = self._world_string(world)
    var level_string = self._level_string(level)
    if stars < 0:
        stars = 0
    if stars > G.MAX_STARS:
        stars = G.MAX_STARS
    self._write_if_larger(world_string + level_string + "stars",stars)

####################################################
#
#   "high" level function reads high score
#    This should be used within rest of game
func read_high_score(world,level):
    var world_string = self._world_string(world)
    var level_string = self._level_string(level)
    return self._read_value(world_string + level_string + "score")

####################################################
#
#   "high" level function reads num_stars
#    This should be used within rest of game
func read_num_stars(world,level):
    var world_string = self._world_string(world)
    var level_string = self._level_string(level)
    return self._read_value(world_string + level_string + "stars")

####################################################
#
#   Only load from encrypted file
#   If anyone tampers with local text file,
#      they cannot change their score or w/e
func read_savegame():
    var read_file = File.new()
    read_file.open_encrypted_with_pass(self.ENCRYPTED_PATH, File.READ, self.password)
    var save_data = read_file.get_line()	# All data is in a single line
    read_file.close()
    self.save_dict = parse_json(save_data)

func _initialize_data():
    self.save_dict["current_world"] = 0;
    self.save_dict["allowed_world"] = 0;

####################################################
#
#   convert world into a string which will act as part of the key-value key for a score
#   CHANGING THIS STRING WILL RESET ALL STARS to zero (or bring old values back from the dead)!
#
func _world_string(world):
    return "world" + String(world) + "_"

####################################################
#
#   convert level into a string which will act as part of the key-value key for a score
#   CHANGING THIS STRING WILL RESET ALL STARS to zero (or bring old values back from the dead)!
#
func _level_string(level):
    return "level" + String(level) + "_"
