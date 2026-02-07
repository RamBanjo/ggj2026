extends Resource
class_name ConsequenceEffect

@export var consequence_type : ConsequenceType
@export var value : String

enum ConsequenceType{
	NOTHING,
	DELTA_SERVER_MEMBERS,
	DELTA_SERVER_ATMOSPHERE,
	TRIGGER_EVENT_FLAG,
	DELTA_MAX_ACTIONS,
	DELTA_MEMBER_INCOME,
	SPAWN_CONVO,
	SPAWN_EVENT,
	SPAWN_MODCASE
}

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
		ConsequenceType.DELTA_MEMBER_INCOME:
			MainChatroom.member_income += get_int_value()

func is_inbox_spawn():
	return consequence_type in [ConsequenceType.SPAWN_CONVO, ConsequenceType.SPAWN_EVENT, ConsequenceType.SPAWN_MODCASE]

func get_msg():
	return FixedMessageDatabase.message_list.get(value, null)

func get_case():
	return CaseDatabase.fixed_cases.get(value, null)
	
func get_event():
	return ChatEventDatabase.fixed_event.get(value, null)
