extends Node2D

@onready var label : Label = $CanvasLayer/Label

const LABEL_BASE_TEXT = "Day {day}\nAtmosphere {cur_atm}/{max_atm}\nMember {cur_mem}/{goal_mem}"

##For pre-scheduled days, use this dictionary. key: the day number. value: the file name of the event.
@export var daily_event_scheduler : Dictionary

##For days that don't exist on the scheduler, random cases will spawn.
@export var fallback_days : Array[DailyEvent]

func _ready() -> void:
	MainChatroom.initialize_new_game()
	update_label()
	
	load_daily_event("test_day")


func update_label():
	label.text = LABEL_BASE_TEXT.format({
		"day": MainChatroom.ingame_day,
		"cur_atm": MainChatroom.server_atmosphere,
		"max_atm": MainChatroom.MAX_SERVER_ATMOSPHERE,
		"cur_mem": MainChatroom.member_count,
		"goal_mem": MainChatroom.MEMBER_WIN_CONDITION
	})

func _on_atm_plus_pressed() -> void:
	MainChatroom.server_atmosphere += 10
	update_label()

func _on_atm_minus_pressed() -> void:
	MainChatroom.server_atmosphere -= 10
	update_label()

func _on_member_plus_pressed() -> void:
	MainChatroom.member_count += 100
	update_label()
	
func _on_member_minus_pressed() -> void:
	MainChatroom.member_count -= 100
	update_label()

const LOSE_TEXT = "The server is dead!"
const WIN_TEXT = "The server is big!"
const NORMAL_END_TEXT = "The server is alright I guess"

@onready var result_label : Label = $CanvasLayer/ResultLabel
var ending_found : bool = false

func end_day():
	
	if ending_found:
		return
	
	if MainChatroom.server_is_dead():
		result_label.text = LOSE_TEXT
		ending_found = true
	elif MainChatroom.server_is_winning():
		result_label.text = WIN_TEXT
		ending_found = true
		
	MainChatroom.ingame_day += 1
	
	if MainChatroom.server_is_boring():
		result_label.text = NORMAL_END_TEXT
		ending_found = true
		
func _on_end_day_button_pressed() -> void:
	end_day()
	update_label()

func load_daily_event(day_id: String) -> DailyEvent:
	var today_events : DailyEvent
	var path : String = "res://res/daily_event/fixed/{day_id}.tres".format({"day_id": day_id})
	
	if ResourceLoader.exists(path):
		print("load_success!!")
		today_events = load(path)
	else:
		print("load failed, we will get a random preset day instead")
		today_events = fallback_days[randi() % len(fallback_days)]
	
	return today_events
