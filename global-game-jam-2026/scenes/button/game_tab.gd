extends TextureRect
class_name GameTabButton

@export_enum("RED:0", "PURPLE:1", "BLUE:2", "GREEN:3", "YELLOW:4") var chosen_color : int
@export var game_tab_active : Array[Texture2D]
@export var game_tab_inactive: Array[Texture2D]

@export var label_text : String
@export var icon : Texture2D

@onready var my_button : Button = $Button
@onready var my_label : Label = $Label
@onready var iconrect : TextureRect = $Icon

var selected_texture : Texture2D
var inactive_texture : Texture2D

func _ready():
	selected_texture = game_tab_active[chosen_color]
	inactive_texture = game_tab_inactive[chosen_color]
		
	texture = inactive_texture
	
	my_label.text = label_text
	iconrect.texture = icon
	

func _on_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		texture = selected_texture
		my_button.modulate = Color.TRANSPARENT
	else:
		texture = inactive_texture
		my_button.modulate = Color.WHITE
