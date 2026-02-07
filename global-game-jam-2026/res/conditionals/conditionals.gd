extends Resource
class_name Conditional

enum ConditionalType{
	RULE_IN_EFFECT,
	RULE_NOT_IN_EFFECT,
	MEMBER_COUNT_GREATER_EQUAL,
	MEMBER_COUNT_LESSER_EQUAL,
	ATMOSPHERE_GREATER_EQUAL,
	ATMOSPHERE_LESSER_EQUAL,
	FLAG_TRIGGERED,
	FLAG_NOT_TRIGGERED
}

@export var condtype : ConditionalType
@export var value : String

func value_as_int() -> int:
	return value.to_int()

func test_conditional():
	match condtype:
		ConditionalType.RULE_IN_EFFECT:
			if not MainChatroom.rule_is_in_effect(value_as_int() as MainChatroom.ServerRules):
				return false
		ConditionalType.RULE_NOT_IN_EFFECT:
			if MainChatroom.rule_is_in_effect(value_as_int() as MainChatroom.ServerRules):
				return false
		ConditionalType.MEMBER_COUNT_GREATER_EQUAL:
			if not MainChatroom.member_count >= value_as_int():
				return false
		ConditionalType.MEMBER_COUNT_LESSER_EQUAL:
			if not MainChatroom.member_count <= value_as_int():
				return false
		ConditionalType.ATMOSPHERE_GREATER_EQUAL:
			if not MainChatroom.server_atmosphere >= value_as_int():
				return false
		ConditionalType.ATMOSPHERE_LESSER_EQUAL:
			if not MainChatroom.server_atmosphere <= value_as_int():
				return false
		ConditionalType.FLAG_TRIGGERED:
			if value not in MainChatroom.triggered_flags:
				return false
		ConditionalType.FLAG_NOT_TRIGGERED:
			if value in MainChatroom.triggered_flags:
				return false
	return true
