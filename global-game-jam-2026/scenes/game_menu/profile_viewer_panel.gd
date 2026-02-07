extends PanelContainer
class_name ProfileViewerPanel

@onready var pfp : TextureRect = $VBoxContainer/TextureRect
@onready var name_label : Label = $VBoxContainer/Label
@onready var desc : RichTextLabel = $VBoxContainer/RichTextLabel

var character_profile : ChatMember

signal hide_profile_panel

func _ready():
	load_profile(character_profile)

func load_profile(new_profile: ChatMember):
	character_profile = new_profile
	if character_profile != null:
		pfp.texture = character_profile.profile_picture
		name_label.text = character_profile.display_name
		desc.text = character_profile.profile_desc
		
func _on_texture_button_pressed() -> void:
	hide()
	hide_profile_panel.emit()
