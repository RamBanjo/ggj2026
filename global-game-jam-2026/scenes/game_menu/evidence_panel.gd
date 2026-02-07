extends PanelContainer
class_name EvidenceViewer

const msg_pack : PackedScene = preload("res://scenes/game_menu/test_chatmessage.tscn")

@onready var scroll_container : ScrollContainer = $VBoxContainer/ScrollContainer
@onready var message_container : VBoxContainer = $VBoxContainer/ScrollContainer/VBoxContainer
@onready var msgname : Label = $VBoxContainer/HBoxContainer/MsgName

const DEFAULT_WINDOW_NAME = "Chatlog from {case}"

signal hide_evidence_panel
signal request_profile_panel

func load_chatlog(title: String, chatlog: Chatlog, override_sender: ChatMember = null, override_target : ChatMember = null, override_witness : Array[ChatMember] = []):
	
	scroll_container.set_deferred("scroll_vertical", 0)
	msgname.text = DEFAULT_WINDOW_NAME.format({"case": title})
	
	message_container.get_children().all(func(x: Node):
		x.queue_free()
		return true
		)
	
	var witnesses_used = 0
	for message in chatlog.chat_messages:
		var new_msg : MsgPanel = msg_pack.instantiate()
		new_msg.my_message = message
		
		match message.speaker.internal_id:
			"reporter":
				new_msg.override_speaker = override_sender
			"offender":
				new_msg.override_speaker = override_target
			"witness":
				new_msg.override_speaker = override_witness[witnesses_used]
				witnesses_used += 1 
			_:
				new_msg.override_speaker = null
		
		message_container.add_child(new_msg)
		new_msg.request_profile.connect(_on_profile_picture_clicked.bind())
	
func _on_profile_picture_clicked(profile : ChatMember):
	request_profile_panel.emit(self, profile)

func _on_texture_button_pressed() -> void:
	hide()
	hide_evidence_panel.emit()
