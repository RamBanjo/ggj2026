extends Node2D

@export var main_game_scene : PackedScene
@onready var canvas : CanvasLayer = $CanvasLayer
@onready var credits_panel : PanelContainer = $CanvasLayer/CreditsPanel
@onready var options_panel : PanelContainer = $CanvasLayer/OptionsPanel

@onready var bgm_vol_bar : HSlider = $CanvasLayer/OptionsPanel/VBoxContainer/HBoxContainer/BGMVolBar
@onready var sfx_vol_bar : HSlider = $CanvasLayer/OptionsPanel/VBoxContainer/HBoxContainer5/SFXVolBar
@onready var show_warning_dropper : OptionButton = $CanvasLayer/OptionsPanel/VBoxContainer/HBoxContainer2/DisableWarning

@onready var main_menu_bgm_player : AudioStreamPlayer = $Title
@onready var click_noise : AudioStreamPlayer = $Click

static var initialized : bool = false

func _ready() -> void:
	GameOptions.load_all_options()
	if not initialized:
		initialize_everything()
		initialized = true
		
		DisplayServer.window_set_size(GameOptions.current_resolution)
		GameOptions.set_fullscreen_status(GameOptions.fullscren_mode)
	
	click_noise.volume_linear = GameOptions.sfx_volume
	sfx_vol_bar.set_value_no_signal(GameOptions.sfx_volume)
	
	main_menu_bgm_player.volume_linear = GameOptions.bgm_volume
	bgm_vol_bar.set_value_no_signal(GameOptions.bgm_volume)
	
func initialize_everything():
	CaseDatabase.initialize_cases()
	FixedMessageDatabase.initialize_messages()
	ChatEventDatabase.initialize_events()
	MembersDatabase.initialize_random_members()

func _on_play_game_button_pressed() -> void:
	click_noise.play()
	MainChatroom.initialize_new_game()
	get_tree().change_scene_to_packed(main_game_scene)

func _on_quit_button_pressed() -> void:
	click_noise.play()
	get_tree().quit()

func hide_side_panels():
	click_noise.play()
	get_tree().call_group("side_panel", "hide")
	
func _on_options_button_pressed() -> void:
	click_noise.play()
	hide_side_panels()
	options_panel.show()

func _on_credits_button_pressed() -> void:
	click_noise.play()
	hide_side_panels()
	credits_panel.show()

func _on_panel_close_button_pressed() -> void:
	click_noise.play()
	hide_side_panels()

func _on_itch_link_0_pressed() -> void:
	click_noise.play()
	OS.shell_open("https://linktr.ee/ramchops")

func _on_itch_link_1_pressed() -> void:
	click_noise.play()
	OS.shell_open("https://www.youtube.com/@Yimaon-1207")

func _on_itch_link_2_pressed() -> void:
	click_noise.play()
	OS.shell_open("https://bsky.app/profile/tao-p3ach.bsky.social")

func _on_itch_link_3_pressed() -> void:
	click_noise.play()
	OS.shell_open("https://youtube.com/@spetosandbox")

func _on_bgm_vol_bar_value_changed(value: float) -> void:
	GameOptions.save_bgm_volume(value)
	main_menu_bgm_player.volume_linear = value

func _on_sfx_vol_bar_value_changed(value: float) -> void:
	GameOptions.save_sfx_volume(value)
	click_noise.volume_linear = value
	click_noise.play()
