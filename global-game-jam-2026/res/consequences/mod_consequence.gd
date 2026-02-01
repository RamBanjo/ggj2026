extends Resource
class_name ModConsequence

@export var consequence_type : ConsequenceType
@export var notif_title : String = "As a result of your actions..."
@export var value : String
@export_multiline var desc : String

enum ConsequenceType{
	NOTHING,
	DELTA_SERVER_MEMBERS,
	DELTA_SERVER_ATMOSPHERE,
	TRIGGER_EVENT_FLAG,
	GOOD_FALSE_REPORT,
	BAD_FALSE_REPORT,
	DELTA_MAX_ACTIONS
}

func is_positive():
	return get_int_value() >= 0

func get_int_value():
	return value.to_int()

func activate_consequence():
	match consequence_type:
		ConsequenceType.DELTA_SERVER_MEMBERS:
			MainChatroom.member_count += get_int_value()
		ConsequenceType.DELTA_SERVER_ATMOSPHERE:
			MainChatroom.server_atmosphere += get_int_value()
		ConsequenceType.DELTA_MAX_ACTIONS:
			MainChatroom.current_max_actions += get_int_value()			
		ConsequenceType.TRIGGER_EVENT_FLAG:
			MainChatroom.triggered_flags.append(value)
			
		#False Reports are only triggered through the False Report button and can be handled 
