extends Resource
class_name ModEvent

@export var internal_id : String

enum ModEventType{
	SPAWN_RANDOM_CASE,
	SPAWN_FIXED_CASE,
	SPAMPOCALYPSE,
	NON_CASE_MESSAGE
}

##The ID of the case or message being called, if this is a SPAWN_FIXED_CASE or NON_CASE_MESSAGE event.
@export var call_id : String
