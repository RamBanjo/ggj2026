extends PanelContainer
class_name TestMsg

@onready var pfp : TextureRect = $HBoxContainer/TextureRect
@onready var name_label : Label = $HBoxContainer/VBoxContainer/Name
@onready var message: RichTextLabel = $HBoxContainer/VBoxContainer/Message

@export var my_message : ChatMessage

func _ready() -> void:
	if my_message != null:
		pfp.texture = my_message.speaker.profile_picture
		name_label.text = my_message.speaker.display_name
		message.text = my_message.text
