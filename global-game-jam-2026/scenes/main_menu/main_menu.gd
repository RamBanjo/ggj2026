extends Node2D

@export var main_game_scene : PackedScene
@onready var canvas : CanvasLayer = $CanvasLayer
@onready var credits_panel : PanelContainer = $CanvasLayer/CreditsPanel
@onready var options_panel : PanelContainer = $CanvasLayer/OptionsPanel

@onready var bgm_vol_bar : HSlider = $CanvasLayer/OptionsPanel/VBoxContainer/HBoxContainer/BGMVolBar
@onready var show_warning_dropper : OptionButton = $CanvasLayer/OptionsPanel/VBoxContainer/HBoxContainer2/DisableWarning

@onready var main_menu_bgm_player : AudioStreamPlayer = $Good

static var initialized : bool = false

func _ready() -> void:
	if not initialized:
		initialize_everything()
		initialized = true
		
	GameOptions.load_all_options()
	main_menu_bgm_player.volume_db = linear_to_db(GameOptions.bgm_volume)
	bgm_vol_bar.set_value_no_signal(GameOptions.bgm_volume)
	
	if GameOptions.show_warning:
		show_warning_dropper.select(0)
	else:
		show_warning_dropper.select(1)
	
func initialize_everything():
	CaseDatabase.initialize_cases()
	FixedMessageDatabase.initialize_messages()
	ChatEventDatabase.initialize_events()
	MembersDatabase.initialize_random_members()

func _on_play_game_button_pressed() -> void:
	MainChatroom.initialize_new_game()
	get_tree().change_scene_to_packed(main_game_scene)

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func hide_side_panels():
	get_tree().call_group("side_panel", "hide")
	
func _on_options_button_pressed() -> void:
	hide_side_panels()
	options_panel.show()

func _on_credits_button_pressed() -> void:
	hide_side_panels()
	credits_panel.show()

func _on_panel_close_button_pressed() -> void:
	hide_side_panels()


func _on_itch_link_0_pressed() -> void:
	OS.shell_open("https://linktr.ee/ramchops")

func _on_itch_link_1_pressed() -> void:
	OS.shell_open("https://www.youtube.com/@Yimaon-1207")

func _on_itch_link_2_pressed() -> void:
	OS.shell_open("https://bsky.app/profile/tao-p3ach.bsky.social")

func _on_itch_link_3_pressed() -> void:
	OS.shell_open("https://youtube.com/@spetosandbox")
	
func _on_bgm_vol_bar_value_changed(value: float) -> void:
	main_menu_bgm_player.volume_db = linear_to_db(value)
	GameOptions.save_bgm_volume(value)

func _on_disable_warning_item_selected(index: int) -> void:
	GameOptions.save_show_warning(index == 0)
