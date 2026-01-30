extends Resource
class_name ConditionalConsequence

enum ConditionalType{
	RULE_IN_EFFECT,
	RULE_NOT_IN_EFFECT,
	MEMBER_COUNT_GREATER_EQUAL,
	MEMBER_COUNT_LESSER_EQUAL,
	ATMOSPHERE_GREATER_EQUAL,
	ATMOSPHERE_LESSER_EQUAL
}

var conditional_list : Array[ConditionalType] = []
var conditional_test_val : Dictionary = {}

func test_conditionals():
	var idx : int = 0
	
	for cond in conditional_list:
		match cond:
			ConditionalType.RULE_IN_EFFECT:
				if not MainChatroom.rule_is_in_effect(conditional_test_val[idx] as MainChatroom.ServerRules):
					return false
			ConditionalType.RULE_NOT_IN_EFFECT:
				if MainChatroom.rule_is_in_effect(conditional_test_val[idx] as MainChatroom.ServerRules):
					return false
			ConditionalType.MEMBER_COUNT_GREATER_EQUAL:
				if not MainChatroom.member_count >= conditional_test_val[idx]:
					return false
			ConditionalType.MEMBER_COUNT_LESSER_EQUAL:
				if not MainChatroom.member_count <= conditional_test_val[idx]:
					return false
			ConditionalType.ATMOSPHERE_GREATER_EQUAL:
				if not MainChatroom.server_atmosphere >= conditional_test_val[idx]:
					return false
			ConditionalType.ATMOSPHERE_LESSER_EQUAL:
				if not MainChatroom.server_atmosphere <= conditional_test_val[idx]:
					return false
	idx += 1
				
	return true
				
var consequence_if_pass : Array[ModConsequence]
var consequence_if_fail : Array[ModConsequence]	
