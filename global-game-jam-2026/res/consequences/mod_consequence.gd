extends Resource
class_name ModConsequence

@export var consequence_type : ConsequenceType
@export var value : String
@export_multiline var desc : String

enum ConsequenceType{
	DELTA_SERVER_MEMBERS,
	DELTA_SERVER_ATMOSPHERE,
	TRIGGER_EVENT_FLAG
}

func get_int_value():
	return value.to_int()
