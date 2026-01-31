extends Resource
class_name ModEvent

@export var internal_id : String

enum ModEventType{
	SPAWN_RANDOM_CASE,
	SPAWN_FIXED_CASE,
	SPAMPOCALYPSE,
	NON_CASE_MESSAGE,
	SPAWN_FALSE_REPORT,
	SPAWN_VALID_CASE,
	SPAWN_SPAMMER
}

##The ID of the case or message being called, if this is a SPAWN_FIXED_CASE or NON_CASE_MESSAGE event.
@export var call_id : String

@export var event_type : ModEventType

func load_fixed_case() -> ModeratorCase:
	var return_case : ModeratorCase = null
	
	return_case = CaseDatabase.fixed_cases.get(call_id, null)
	
	return return_case
	
func load_message() -> ChatMessage:
	var return_mess : ChatMessage = null
	
	return_mess = load("res://res/chatlogs/chat_message/fixed/{case_id}.tres".format({"case_id": call_id}))
	
	return return_mess
