extends PanelContainer
class_name MsgPanel

@onready var pfp : TextureRect = $HBoxContainer/TextureRect
@onready var name_label : Label = $HBoxContainer/VBoxContainer/Name
@onready var message: RichTextLabel = $HBoxContainer/VBoxContainer/Message

@export var override_speaker : ChatMember = null
@export var my_message : ChatMessage

func _ready() -> void:
	
	
	
	if my_message != null:
		if override_speaker != null:
			pfp.texture = override_speaker.profile_picture
		else:		
			pfp.texture = my_message.speaker.profile_picture
		
		if pfp.texture == null:
			pfp.hide()
		
		
		if override_speaker != null:
			name_label.text = override_speaker.display_name
		else:
			name_label.text = my_message.speaker.display_name
		
		if name_label.text == "":
			name_label.hide()
		
		message.text = my_message.text
