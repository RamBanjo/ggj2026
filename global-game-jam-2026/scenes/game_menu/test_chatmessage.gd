extends PanelContainer
class_name MsgPanel

@onready var pfp : TextureRect = $HBoxContainer/TextureRect
@onready var name_label : Label = $HBoxContainer/VBoxContainer/Name
@onready var message: RichTextLabel = $HBoxContainer/VBoxContainer/Message

@export var override_speaker : ChatMember = null
@export var my_message : ChatMessage

signal request_profile

func _ready() -> void:
	
	if my_message != null:
		
		if override_speaker == null:
			override_speaker = my_message.speaker
		
		pfp.texture = override_speaker.profile_picture
		
		if pfp.texture == null:
			pfp.hide()
		
		name_label.text = override_speaker.display_name
		
		if name_label.text == "":
			name_label.hide()
		
		message.text = my_message.text

func _pfp_clicked() -> void:
	request_profile.emit(override_speaker)
