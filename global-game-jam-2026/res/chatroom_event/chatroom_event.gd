extends Resource
class_name ChatroomEvent

@export var internal_id : String
@export var title : String
@export var sender : ChatMember
@export_multiline var desc : String
@export var chatlog : Chatlog

@export var options : PackedStringArray
@export var option_cost : Array[int]
@export_enum("0", "1", "2", "3") var default_ignore : int = 1

@export var consequence_0 : Array[ModConsequence]
@export var consequence_1 : Array[ModConsequence]
@export var consequence_2 : Array[ModConsequence]
@export var consequence_3 : Array[ModConsequence]

func is_valid_idx(idx: int):
	return idx >= 0 and idx < len(options)

func player_can_afford(idx: int):
	if idx == default_ignore:
		return true
	
	return MainChatroom.remaining_actions_today >= option_cost.get(idx)

func activate_default_consequence():
	activate_consequence(default_ignore)

func get_first_consequence(idx: int):
	match idx:
		0:
			return consequence_0[0]
		1:
			return consequence_1[0]
		2:
			return consequence_2[0]
		3:
			return consequence_3[0]
			
	return consequence_0[0]

func activate_consequence(idx: int):
	match idx:
		0:
			consequence_0.all(func(x: ModConsequence):
				x.activate_consequence()
				return true
				)
		1:
			consequence_1.all(func(x: ModConsequence):
				x.activate_consequence()
				return true
				)
		2:
			consequence_2.all(func(x: ModConsequence):
				x.activate_consequence()
				return true
				)
		3:
			consequence_3.all(func(x: ModConsequence):
				x.activate_consequence()
				return true
				)
