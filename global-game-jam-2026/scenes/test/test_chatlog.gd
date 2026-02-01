extends PanelContainer
class_name TestLog

@onready var chat_message_vbox : VBoxContainer = $VBoxContainer/ScrollContainer/VBoxContainer

@export var chatlog : Chatlog

const msg_pack : PackedScene = preload("res://scenes/game_menu/test_chatmessage.tscn")

func _ready() -> void:
	for msg in chatlog.chat_messages:
		
		var new_msg : MsgPanel = msg_pack.instantiate()
		new_msg.my_message = msg
		
		chat_message_vbox.add_child(new_msg)
