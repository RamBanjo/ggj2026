extends Resource
class_name GameOptions

static var bgm_volume : float = 1.0
static var current_song_progress : float = 0.0
static var show_warning : bool = true

static func load_all_options():
	load_bgm_volume()
	load_show_warning()

static func save_bgm_volume(value: float):
	bgm_volume = value
	
	var config = ConfigFile.new()
	
	config.set_value("options", "volume", value)
	
	config.save("user://options.cfg")
	
static func load_bgm_volume():
	var config = ConfigFile.new()
	
	var err = config.load("user://options.cfg")
	
	if err != OK:
		save_bgm_volume(1)
		return
	
	bgm_volume = config.get_value("options", "volume", 1)

static func save_show_warning(value: bool):
	show_warning = value
	var config = ConfigFile.new()
	
	config.set_value("options", "warning", value)
	
	config.save("user://options.cfg")
	
static func load_show_warning():
	var config = ConfigFile.new()
	
	var err = config.load("user://options.cfg")
	
	if err != OK:
		save_show_warning(true)
		return
	
	show_warning = config.get_value("options", "warning", true)
