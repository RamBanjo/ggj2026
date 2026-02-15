extends Resource
class_name GameOptions

static var bgm_volume : float = 1.0
static var sfx_volume : float = 1.0
static var current_song_progress : float = 0.0
static var show_warning : bool = true

static var current_resolution : Vector2i = Vector2i (1280, 720)
static var fullscren_mode : bool = false
const RESOLUTION_OPTIONS : Array[Vector2i] = [
	Vector2i(960, 540),
	Vector2i(1280, 720),
	Vector2i(1600, 900),
	Vector2i(1920, 1080)
]

static func get_res_as_string(res: Vector2i):
	return "{x} X {y}".format({"x":res.x, "y":res.y})

static func load_all_options():
	load_bgm_volume()
	load_show_warning()
	load_screen_settings()

static func save_screen_settings(size: Vector2i, is_full: bool):
	current_resolution = size
	fullscren_mode = is_full
	
	var config = ConfigFile.new()
	config.set_value("res", "x", size.x)
	config.set_value("res", "y", size.y)
	config.set_value("res", "full", is_full)
	
	config.save("user://options.cfg")
	
static func load_screen_settings():
	pass

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

static func save_sfx_volume(sfxvol : float):
	sfx_volume = sfxvol
	
	var config = ConfigFile.new()
	
	config.set_value("options", "sfx", sfxvol)
	
	config.save("user://options.cfg")
	
static func load_sfx_volume():
	var config = ConfigFile.new()
	
	var err = config.load("user://options.cfg")
	
	if err != OK:
		save_bgm_volume(1)
		return
	
	bgm_volume = config.get_value("options", "sfx", 1)


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

static func set_fullscreen_status(is_full : bool):
	if is_full:
		#true
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		
	else:
		#false
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
