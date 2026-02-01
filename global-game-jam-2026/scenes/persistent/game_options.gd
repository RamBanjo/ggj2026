extends Resource
class_name GameOptions

static var bgm_volume : float = 1.0
static var current_song_progress : float = 0.0

static func load_all_options():
	load_bgm_volume()

static func save_bgm_volume(value: float):
	bgm_volume = value
	
	var config = ConfigFile.new()
	
	config.set_value("options", "volume", value)
	
	config.save("user://tutorial.cfg")
	
static func load_bgm_volume():
	var config = ConfigFile.new()
	
	var err = config.load("user://tutorial.cfg")
	
	if err != OK:
		save_bgm_volume(1)
		return
	
	bgm_volume = config.get_value("options", "volume", 1)
