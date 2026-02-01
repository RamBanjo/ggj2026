extends Node2D
class_name ChatTabGroup

@export_enum("RED:0", "PURPLE:1", "BLUE:2", "GREEN:3", "YELLOW:4") var chosen_color : int

@export var buttonslist : Array[GameTabButton]
@export var bg_list : Array[Texture2D]
@export var butt_group : ButtonGroup

@onready var bg : TextureRect = $CanvasLayer/TextureRect

signal request_change_panel

func _ready() -> void:
	
	butt_group = ButtonGroup.new()
	
	buttonslist.all(func(x: GameTabButton):
		x.my_button.button_group = butt_group
		return true
		)
	
	buttonslist[0].my_button.button_pressed = true
	butt_group.pressed.connect(_tab_changed.bind())
	
	var selected_tab : GameTabButton = butt_group.get_pressed_button().get_parent() as GameTabButton
	bg.texture = bg_list[selected_tab.chosen_color]
	
func _tab_changed(button: Button):
	var selected_tab : GameTabButton = button.get_parent() as GameTabButton
	bg.texture = bg_list[selected_tab.chosen_color]
	request_change_panel.emit(selected_tab.chosen_color)
