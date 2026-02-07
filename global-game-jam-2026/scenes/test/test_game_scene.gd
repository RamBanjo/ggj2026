extends Node2D

@onready var label : Label = $CanvasLayer/Label

const LABEL_BASE_TEXT = "Day {day}\nAtmosphere {cur_atm}/{max_atm}\nMember {cur_mem}/{goal_mem}"

##For pre-scheduled days, use this dictionary. key: the day number. value: the file name of the event.
@export var daily_event_scheduler : Dictionary

##For days that don't exist on the scheduler, random cases will spawn.
@export var fallback_days : Array[DailyEvent]

@export var event_button_scene : PackedScene

@onready var today_event_button_container : VBoxContainer = $CanvasLayer/ScrollContainer/VBoxContainer

@onready var message_viewer : MessageViewer = $CanvasLayer/MessageViewer

func _ready() -> void:
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

func load_daily_event(day_id: String):
	var today_events : DailyEvent
	var path : String = "res://res/daily_event/fixed/{day_id}.tres".format({"day_id": day_id})
	
	if ResourceLoader.exists(path):
		print("load_success!!")
		today_events = load(path)
	else:
		print("load failed, we will get a random preset day instead")
		today_events = fallback_days[randi() % len(fallback_days)]
	
	for event in today_events.today_events:
		match event.event_type:
			ModEvent.ModEventType.SPAWN_RANDOM_CASE:
				instantiate_button_for_case(CaseDatabase.get_random_case())
			ModEvent.ModEventType.SPAWN_FIXED_CASE:
				instantiate_button_for_case(CaseDatabase.fixed_cases.get(event.call_id))
			ModEvent.ModEventType.SPAWN_FALSE_REPORT:
				instantiate_button_for_case(CaseDatabase.get_random_false())
			ModEvent.ModEventType.SPAWN_VALID_CASE:
				instantiate_button_for_case(CaseDatabase.get_random_legit())
			ModEvent.ModEventType.SPAWN_SPAMMER:
				instantiate_button_for_case(CaseDatabase.get_random_spammer())
			ModEvent.ModEventType.SPAMPOCALYPSE:
				instantiate_button_for_case(CaseDatabase.get_random_spammer())
				instantiate_button_for_case(CaseDatabase.get_random_spammer())
				instantiate_button_for_case(CaseDatabase.get_random_spammer())
				instantiate_button_for_case(CaseDatabase.get_random_spammer())
				instantiate_button_for_case(CaseDatabase.get_random_spammer())
			ModEvent.ModEventType.NON_CASE_MESSAGE:
				instantiate_button_for_msg(FixedMessageDatabase.message_list.get(event.call_id))

func _on_report_button_pressed(object, type: String, button: ModCaseButton):
	if type == "msg":
		message_viewer.load_message(object as ChatMessage, button.assigned_msg_owner)
		return
		
	if type == "case":
		message_viewer.load_mod_report(object as ModeratorCase, button.assigned_msg_owner, button.assigned_report_target)
		return
	

func instantiate_button_for_case(newcase: ModeratorCase):
	var newbutton : ModCaseButton = event_button_scene.instantiate()
	newbutton.report = newcase
	today_event_button_container.add_child(newbutton)
	newbutton.request_show_event.connect(_on_report_button_pressed.bind())

func instantiate_button_for_msg(newmessage: ChatMessage):
	var newbutton : ModCaseButton = event_button_scene.instantiate()
	newbutton.message = newmessage
	today_event_button_container.add_child(newbutton)
	newbutton.request_show_event.connect(_on_report_button_pressed.bind())
		
func clear_daily_buttons():
	for button in today_event_button_container.get_children():
		if button is ModCaseButton:
			if button.report != null:
				for consq : ModConsequence in button.report.ignore_consequences:
					consq.activate_consequence()
					
		button.queue_free()
