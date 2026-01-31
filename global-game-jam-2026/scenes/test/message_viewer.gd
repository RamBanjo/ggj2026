extends ScrollContainer

@onready var action_button_container : HBoxContainer = $VBoxContainer/HBoxContainer

@onready var reporter_name : MemberAddress = $VBoxContainer/HBoxContainer2/ReporterAddress
@onready var offender_name : MemberAddress = $VBoxContainer/HBoxContainer2/OffenderAddress

@onready var body_text : RichTextLabel = $VBoxContainer/RichTextLabel

@onready var evidence_button : Button = $VBoxContainer/EvidenceButton

func load_message(modmail: ChatMessage):
	offender_name.hide()
	evidence_button.hide()
	action_button_container.hide()
	
	reporter_name.update_member(modmail.speaker, "Reporter")

func load_mod_report(report: ModeratorCase):
	offender_name.show()
	evidence_button.show()
	action_button_container.show()
	
	reporter_name.update_member(report.case_owner, "Reporter")
	offender_name.update_member(report.report_target, "Offender")
