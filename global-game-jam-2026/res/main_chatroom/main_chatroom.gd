extends Resource
class_name MainChatroom

static var member_count : int:
	set(value):
		member_count = value
		if member_count <= 1:
			member_count = 1
	get:
		return member_count
		
static var server_atmosphere : int:
	set(value):
		server_atmosphere = value
		if server_atmosphere <= MIN_SERVER_ATMOSPHERE:
			server_atmosphere = MIN_SERVER_ATMOSPHERE
		if server_atmosphere >= MAX_SERVER_ATMOSPHERE:
			server_atmosphere = MAX_SERVER_ATMOSPHERE
	get:
		return server_atmosphere
		
static var ingame_day : int
static var remaining_actions_today: int
static var current_max_actions: int
static var member_income : int

const MEMBER_LOSE_THRESHOLD = 10
const MIN_SERVER_ATMOSPHERE = 0
const MAX_SERVER_ATMOSPHERE = 100

const MEMBER_WIN_CONDITION = 500
const ATMOSPHERE_WIN_CONDITION = 80
const ATMOSPHERE_LOSE_CONDITION = 0
const TIME_LIMIT = 15

const DEFAULT_DAILY_ACTIONS = 3
const DEFAULT_MEMBER_COUNT = 50
const DEFAULT_ATMOSPHERE = 50

const DEFAULT_MEMBER_INCOME = 20

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

static var triggered_flags : PackedStringArray = []

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
	member_income = DEFAULT_MEMBER_INCOME
	remaining_actions_today = current_max_actions
	
	current_rules = DEFAULT_RULES
	triggered_flags.clear()

static func server_is_dead():
	if member_count < MEMBER_LOSE_THRESHOLD or server_atmosphere <= ATMOSPHERE_LOSE_CONDITION:
		return true
		
	return false
	
static func server_is_winning():
	if member_count >= MEMBER_WIN_CONDITION and server_atmosphere >= ATMOSPHERE_WIN_CONDITION and ingame_day >= TIME_LIMIT:
		return true
		
	return false
	
static func server_is_boring():
	if ingame_day >= TIME_LIMIT and not server_is_winning():
		return true
		
	return false

static func player_cannot_take_action():
	return remaining_actions_today <= 0
	
static func member_count_valid(min: int = -1, max: int = -1):
	if min == -1 and max == -1:
		return true
		
	if min != -1:
		return member_count > min
	elif max != -1:
		return member_count < max
	else:
		return member_count > min and member_count < max
		
static func atmosphere_level_valid(min: int = -1, max: int = -1):
	if min == -1 and max == -1:
		return true
		
	if min != -1:
		return server_atmosphere > min
	elif max != -1:
		return server_atmosphere < max
	else:
		return server_atmosphere > min and server_atmosphere < max
