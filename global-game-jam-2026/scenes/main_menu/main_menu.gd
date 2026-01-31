extends Node2D

@export var main_game_scene : PackedScene
@onready var canvas : CanvasLayer = $CanvasLayer
@onready var credits_panel : PanelContainer = $CanvasLayer/CreditsPanel
@onready var options_panel : PanelContainer = $CanvasLayer/OptionsPanel

func _ready() -> void:
	initialize_everything()
	
func initialize_everything():
	CaseDatabase.initialize_cases()
	FixedMessageDatabase.initialize_messages()

func _on_play_game_button_pressed() -> void:
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
