extends Resource
class_name MainChatroom

static var member_count : int
static var server_atmosphere : int
static var ingame_day : int
static var remaining_actions_today: int
static var current_max_actions: int

const MEMBER_LOSE_THRESHOLD = 0
const MIN_SERVER_ATMOSPHERE = 0
const MAX_SERVER_ATMOSPHERE = 100

const MEMBER_WIN_CONDITION = 500
const ATMOSPHERE_WIN_CONDITION = 80

const ATMOSPHERE_LOSE_CONDITION = 0

const DEFAULT_DAILY_ACTIONS = 3
const DEFAULT_MEMBER_COUNT = 10
const DEFAULT_ATMOSPHERE = 50

enum ServerRules{
	BE_NICE,
	NO_ILLEGAL,
	NO_HARASS,
	NO_FALSE_ACCUSE,
	NO_DOXXING,
}

const DEFAULT_RULES : Array[ServerRules] = [
	ServerRules.BE_NICE, ServerRules.NO_ILLEGAL, ServerRules.NO_HARASS, ServerRules.NO_FALSE_ACCUSE
]
static var current_rules : Array[ServerRules]

static func rule_is_in_effect(check_rule: ServerRules):
	return check_rule in current_rules
	
static func add_rule(new_rule: ServerRules):
	if new_rule not in current_rules:
		current_rules.append(new_rule)

static func remove_rule(remove_this: ServerRules):
	current_rules.erase(remove_this)

static func initialize_new_game():
	member_count = DEFAULT_MEMBER_COUNT
	server_atmosphere = DEFAULT_ATMOSPHERE
	ingame_day = 1
	current_max_actions = DEFAULT_DAILY_ACTIONS
	remaining_actions_today = current_max_actions
	
	current_rules = DEFAULT_RULES

static func server_is_dead():
	if member_count < MEMBER_LOSE_THRESHOLD or server_atmosphere <= ATMOSPHERE_LOSE_CONDITION:
		return true
		
	return false
	
static func server_is_winning():
	if member_count >= MEMBER_WIN_CONDITION and server_atmosphere >= ATMOSPHERE_WIN_CONDITION:
		return true
		
	return false
