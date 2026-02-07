extends Resource
class_name ChatroomEvent

@export var internal_id : String
@export var title : String
@export var sender : ChatMember
@export_multiline var desc : String
@export var chatlog : Chatlog

@export var options : PackedStringArray
@export var option_cost : Array[int]
@export var spawn_conditions : Array[Conditional]

@export_enum("0", "1", "2", "3") var default_ignore : int = 1

@export var consequences : Array[ModConsequence]

func can_spawn():
	for cond in spawn_conditions:
		if not cond.test_conditional():
			return false
	return true

func is_valid_idx(idx: int):
	return idx >= 0 and idx < len(options)

func player_can_afford(idx: int):
	if idx == default_ignore:
		return true
	
	return MainChatroom.remaining_actions_today >= option_cost.get(idx)

func activate_default_consequence():
	activate_consequence(default_ignore)

func activate_consequence(idx: int):
	consequences[idx].activate_consequence()
