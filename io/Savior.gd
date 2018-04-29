extends Node

var savegame = File.new() # file
var encryptgame = File.new() # file
const SAVE_TEXT = "user://save_game_data.dat"
const SAVE_ENCRYPTED = "user://save_game_data.bin"
var password

var save_dict = {} # variable to store data

####################################################
#
#	On first run, create local files to save the data
#
#   On subsequent runs, load previously saved data
func _ready():
	self.password = OS.get_unique_id()
	self._initialize_data()				# Don't need to do this if local files exist
	self._create_files_prn()			# will save files if they do not exist
	self.read_savegame()				# will read default at first, then updated value if anything has been saved
	self.save_high_score(55)

####################################################
#
#   Create local files if necessary
func _create_files_prn():
	if not savegame.file_exists(SAVE_TEXT):
		self._create_save(SAVE_TEXT,false)		# false = no encryption
	if not encryptgame.file_exists(SAVE_ENCRYPTED):
		self._create_save(SAVE_ENCRYPTED)

####################################################
#
#   Save data in one of two formats:
#      secure binary format (default)
#      debug-friendly text format
func _create_save(filename, encrypt = true):
	var create_file = File.new()
	if(encrypt):
		create_file.open_encrypted_with_pass(filename, File.WRITE, self.password)
	else:
		create_file.open(filename, File.WRITE)
	create_file.store_string(to_json(self.save_dict))
	create_file.close()

####################################################
#
#   Save both visible and encrypted files
func _save():
	self._create_save(SAVE_TEXT,false)		# false = no encryption
	self._create_save(SAVE_ENCRYPTED)

####################################################
#
#   "low" level function just saves value and writes to disk
func _write_value(field, value):
	self.save_dict[field] = value;		# Add value to dictionary
	self._save()						# Save data to disk

####################################################
#
#   "low" level function just returns value
func _read_value(field):

	if(self.save_dict.has(field)):
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

func save_high_score(score):
	self._write_if_larger("highscore",score)

####################################################
#
#   Only load from encrypted file
#   If anyone tampers with local text file,
#      they cannot change their score or w/e
func read_savegame():
	var read_file = File.new()
	read_file.open_encrypted_with_pass(self.SAVE_ENCRYPTED, File.READ, self.password)
	var save_data = read_file.get_line()	# All data is in a single line
	read_file.close()
	self.save_dict = parse_json(save_data)
	print(save_data)
	print(self.save_dict)

func _initialize_data():
	self.save_dict["current_world"] = 0;
	self.save_dict["allowed_world"] = 0;
