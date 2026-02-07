extends PanelContainer
class_name MessageViewer

@onready var action_button_container : HBoxContainer = $VBoxContainer/VBoxContainer/HBoxContainer
@onready var nonfree_mod_action_button : Array[Button] = [$VBoxContainer/VBoxContainer/HBoxContainer/WarnOffenderButton, $VBoxContainer/VBoxContainer/HBoxContainer/KickOffenderButton, $VBoxContainer/VBoxContainer/HBoxContainer/FalseReportButton]

@onready var event_button_container : HBoxContainer = $VBoxContainer/HBoxContainer3
@onready var event_buttons : Array[Button] = [$VBoxContainer/HBoxContainer3/Op0, $VBoxContainer/HBoxContainer3/Op1, $VBoxContainer/HBoxContainer3/Op2, $VBoxContainer/HBoxContainer3/Op3]

@onready var reporter_name : MemberAddress = $VBoxContainer/HBoxContainer2/ReporterAddress
@onready var offender_name : MemberAddress = $VBoxContainer/HBoxContainer2/OffenderAddress

@onready var body_text : RichTextLabel = $VBoxContainer/ScrollContainer/RichTextLabel

@onready var evidence_button : Button = $VBoxContainer/VBoxContainer/EvidenceButton

@onready var msgnamelabel : Label = $VBoxContainer/HBoxContainer/MsgName

signal request_hide_me

const EVIDENCE_BUTTON_TXT : String = "Show Evidence"
const RELEVANCE_TXT : String = "Show Relevant Conversation"

func load_event(event: ChatroomEvent, override_sender: ChatMember = null):
	self.show()
	
	offender_name.hide()
	if event.chatlog == null:
		evidence_button.hide()
	else:
		evidence_button.show()
		evidence_button.text = RELEVANCE_TXT
	
	action_button_container.hide()
	event_button_container.show()
	disable_buttons_check()

	msgnamelabel.text = event.title
	body_text.text = event.desc
	
	if event.sender != null:
		reporter_name.update_member(event.sender)
	else:
		reporter_name.update_member(override_sender)
		
	var idx = 0
	
	for button in event_buttons:
		button.hide()
		
		if event.is_valid_idx(idx):
			button.show()
			button.text = event.options[idx]
			button.disabled = not event.player_can_afford(idx)
		idx += 1

func load_message(modmail: ChatMessage, override_sender: ChatMember = null):
	self.show()

	offender_name.hide()
	evidence_button.hide()
	action_button_container.hide()
	event_button_container.hide()

	if modmail.chatlog == null:
		evidence_button.hide()
	else:
		evidence_button.show()
		evidence_button.text = RELEVANCE_TXT

	msgnamelabel.text = modmail.title
	
	if modmail.speaker != null:
		reporter_name.update_member(modmail.speaker)
	else:
		reporter_name.update_member(override_sender)
		
	body_text.text = modmail.text

func load_mod_report(report: ModeratorCase, override_sender: ChatMember = null, override_target : ChatMember = null):
	self.show()
	offender_name.show()
	evidence_button.show()
	
	evidence_button.text = EVIDENCE_BUTTON_TXT
	
	action_button_container.show()
	event_button_container.hide()
	
	msgnamelabel.text = report.case_display_name
	if report.case_owner != null:
		reporter_name.update_member(report.case_owner, "Reporter")
	else:
		reporter_name.update_member(override_sender, "Reporter")
		
	if report.report_target != null:	
		offender_name.update_member(report.report_target, "Offender")
	else:
		offender_name.update_member(override_target, "Offender")
		
	body_text.text = report.case_description
	
	disable_buttons_check()

func _on_texture_button_pressed() -> void:
	request_hide_me.emit()

signal ignore
signal warn_offender
signal kick_offender
signal false_report

func disable_buttons_check():
	if MainChatroom.player_cannot_take_action():
		nonfree_mod_action_button.all(func(x: Button):
			x.disabled = true
			return true)
		event_buttons.all(func(x:Button):
			x.disabled = true
			return true)
	else:
		nonfree_mod_action_button.all(func(x: Button):
			x.disabled = false
			return true)
		event_buttons.all(func(x:Button):
			x.disabled = false
			return true)		

func _on_ignore_button_pressed() -> void:
	ignore.emit()

func _on_warn_offender_button_pressed() -> void:
	warn_offender.emit()

func _on_kick_offender_button_pressed() -> void:
	kick_offender.emit()

func _on_false_report_button_pressed() -> void:
	false_report.emit()

signal event_option_chosen

func _on_op_0_pressed() -> void:
	event_option_chosen.emit(0)

func _on_op_1_pressed() -> void:
	event_option_chosen.emit(1)

func _on_op_2_pressed() -> void:
	event_option_chosen.emit(2)

func _on_op_3_pressed() -> void:
	event_option_chosen.emit(3)

signal request_evidence
func _on_evidence_button_pressed() -> void:
	request_evidence.emit()

signal request_profile
func _request_profile(member: ChatMember):
	request_profile.emit(self, member)
