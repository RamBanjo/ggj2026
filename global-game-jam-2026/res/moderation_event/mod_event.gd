extends Resource
class_name ModEvent

@export var internal_id : String

enum ModEventType{
	SPAWN_RANDOM_CASE,
	SPAWN_FIXED_CASE,
	SPAMPOCALYPSE,
	NON_CASE_MESSAGE,
	RANDOM_MESSAGE,
	SPAWN_FALSE_REPORT,
	SPAWN_VALID_CASE,
	SPAWN_SPAMMER,
	SPAWN_FIXED_EVENT,
	SPAWN_RANDOM_EVENT
}

##The ID of the case or message being called, if this is a SPAWN_FIXED_CASE or NON_CASE_MESSAGE event.
@export var call_id : String

@export var event_type : ModEventType

##The event flag that must be triggered for this event to appear. If blank, it always spawns, unless prevented by avoid_event_flag
@export var req_event_flag : String

##The event flag that will cause this event to become invalid.
@export var avoid_event_flag : String

@export var min_spawn_atmos : int = -1
@export var max_spawn_atmos : int = -1
@export var min_spawn_member : int = -1
@export var max_spawn_member : int = -1

func minmax_conditions_met():
	return MainChatroom.atmosphere_level_valid(min_spawn_atmos, max_spawn_atmos) and MainChatroom.member_count_valid(min_spawn_member, max_spawn_member)

func can_spawn():
	if req_event_flag == "":
		return avoid_event_flag not in MainChatroom.triggered_flags and minmax_conditions_met()
		
	return req_event_flag in MainChatroom.triggered_flags and avoid_event_flag not in MainChatroom.triggered_flags and minmax_conditions_met()

func load_fixed_case() -> ModeratorCase:
	var return_case : ModeratorCase = null
	
	return_case = CaseDatabase.fixed_cases.get(call_id, null)
	
	return return_case
	
func load_message() -> ChatMessage:
	var return_mess : ChatMessage = null
	
	return_mess = load("res://res/chatlogs/chat_message/fixed/{case_id}.tres".format({"case_id": call_id}))
	
	return return_mess
