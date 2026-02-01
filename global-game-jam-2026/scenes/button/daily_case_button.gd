extends Button
class_name ModCaseButton

signal request_show_event

var message : ChatMessage
var report : ModeratorCase
var event : ChatroomEvent

var assigned_msg_owner : ChatMember
var assigned_report_target : ChatMember
var assigned_witnesses : Array[ChatMember]

const MODMAIL_MSG : String = "Message From {name}: {topic}" 
const REPORT_MSG : String = "Report From {name}: {topic}"

var is_case : bool = false
var is_msg : bool = false
var is_event : bool = false

func _ready() -> void:
	if report != null:
		text = REPORT_MSG.format({"name": assigned_msg_owner.display_name, "topic": report.case_display_name})
		is_case = true
	elif message != null:
		text = MODMAIL_MSG.format({"name": assigned_msg_owner.display_name, "topic": message.title})
		is_msg = true		
	elif event != null:
		text = MODMAIL_MSG.format({"name":assigned_msg_owner.display_name, "topic": event.title})
		is_event = true	
	else:
		text = "You arent supposed to be here"

func _on_pressed() -> void:
	if is_case:
		request_show_event.emit(report, "case", self)
		return
		
	if is_msg:
		request_show_event.emit(message, "msg", self)
		return
		
	if is_event:
		request_show_event.emit(event, "eve", self)
		return

func activate_event_consequences(idx: int):
	if event != null:
		event.activate_consequence(idx)

func apply_ignore_consequences():
	if report != null:
		for consq in report.ignore_consequences:
			consq.activate_consequence()
		return
		
	if event != null:
		event.activate_default_consequence()
			
func apply_warn_consequences():
	if report != null:
		for consq in report.warning_consequences:
			consq.activate_consequence()
			
func apply_kick_consequences():
	if report != null:
		for consq in report.kick_consequences:
			consq.activate_consequence()

func apply_false_report_consq():
	if report != null:
		for consq in report.false_report_consequences:
			consq.activate_consequence()

func get_event_name():
	if is_case:
		return report.case_display_name
		
	if is_msg:
		return message.title
		
	if is_event:
		return event.title
		
	return "Something...?"
