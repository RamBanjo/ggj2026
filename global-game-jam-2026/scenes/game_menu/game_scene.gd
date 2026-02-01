extends Node2D

@onready var daylabel : Label = $DayCounter/PanelContainer/HBoxContainer/VBoxContainer/TodayLabel

const LABEL_BASE_TEXT = "Day {day}\nActions: {act}/{maxact}"

##For pre-scheduled days, use this dictionary. key: the day number. value: the file name of the event.
@export var daily_event_scheduler : Dictionary

##For days that don't exist on the scheduler, random cases will spawn.
@export var fallback_days : Array[DailyEvent]

@export var event_button_scene : PackedScene

@onready var today_event_button_container : VBoxContainer = $ReadReportsCanvas/ScrollContainer/PanelContainer/TodayEventContainer

@onready var message_viewer : MessageViewer = $ReadReportsCanvas/MessageViewer
@onready var evidence_viewer : EvidenceViewer = $ReadReportsCanvas/EvidencePanel

@onready var atmosphere_bar : ProgressBar = $ReadStatusCanvas/PanelContainer/VBoxContainer/HBoxContainer/ProgressBar
@onready var member_counter : Label = $ReadStatusCanvas/PanelContainer/VBoxContainer/HBoxContainer2/MemberCount
@onready var member_goal : Label = $ReadStatusCanvas/PanelContainer/VBoxContainer/HBoxContainer3/MemberGoal

@onready var notify_canvas = $NotificationCanvas

@onready var notif_panel : NotifierPanel = $NotificationCanvas/BackgroundBlocker/ConsequencePanel
@onready var game_end_panel : NotifierPanel = $NotificationCanvas/BackgroundBlocker/GameOverPanel

@onready var option_canvas = $OptionsCanvas

@onready var tabs : ChatTabGroup = $TestGameBg

@export var canvas_order : Array[CanvasLayer]

static var is_notifying : bool = false

var current_event_button : ModCaseButton
var current_event_chatlog : Chatlog

@onready var good_bgm : AudioStreamPlayer = $Good
@onready var evil_bgm : AudioStreamPlayer = $Dark

@onready var bgm_vol_slider : HSlider = $OptionsCanvas/BackgroundBlocker/PanelContainer/VBoxContainer/HBoxContainer/BGMVolSlider

@export var good_end_bg : Texture2D
@export var normal_end_bg : Texture2D
@export var bad_end_bg : Texture2D
@export var ending_rect : TextureRect

func _ready() -> void:
	is_notifying = false
	update_label()
	load_event_for_day(1)

func set_current_bgm():
	if MainChatroom.server_atmosphere >= 50:
		evil_bgm.volume_linear = 0
		good_bgm.volume_linear = GameOptions.bgm_volume
		
	else:
		
		var current_ratio : float =  float(MainChatroom.server_atmosphere) / 50.0
		 
		evil_bgm.volume_linear = lerpf(1, 0, current_ratio) * GameOptions.bgm_volume
		good_bgm.volume_linear = lerpf(0, 1, current_ratio) * GameOptions.bgm_volume


	print(evil_bgm.volume_linear)
	print(good_bgm.volume_linear)

func update_label():
	daylabel.text = LABEL_BASE_TEXT.format({
		"day": MainChatroom.ingame_day,
		"act": MainChatroom.remaining_actions_today,
		"maxact": MainChatroom.current_max_actions
	})
	
	atmosphere_bar.value = MainChatroom.server_atmosphere
	member_counter.text = str(MainChatroom.member_count)
	member_goal.text = str(MainChatroom.MEMBER_WIN_CONDITION)
	
	set_current_bgm()

#@onready var result_label : Label = $CanvasLayer/ResultLabel
var ending_found : bool = false

func end_day():
	current_event_button = null
	current_event_chatlog = null
	
	message_viewer.hide()
	evidence_viewer.hide()
	tabs.butt_group.get_buttons()[0].button_pressed = true
	
	var work_skipped = clear_daily_buttons()
	
	if ending_found:
		return
		
	MainChatroom.ingame_day += 1
	
	if MainChatroom.server_is_boring():
		show_normal_ending()
		ending_found = true
		
	MainChatroom.member_count += MainChatroom.member_income	
		
	if work_skipped:
		show_ignore_case_new_day(MainChatroom.member_income)
	else:
		show_new_day(MainChatroom.member_income)
		
	if MainChatroom.server_is_dead():
		show_bad_ending()
		ending_found = true
	elif MainChatroom.server_is_winning():
		show_good_ending()
		ending_found = true
	
	load_event_for_day(MainChatroom.ingame_day)
	update_label()
		
	
		
func _on_end_day_button_pressed() -> void:
	end_day()
	update_label()

func load_event_for_day(day: int):
	load_daily_event(daily_event_scheduler.get(day, ""))
	

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
		
		if not event.can_spawn():
			continue
		
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
			ModEvent.ModEventType.SPAWN_FIXED_EVENT:
				instantiate_button_for_event(ChatEventDatabase.fixed_event.get(event.call_id))
				
func _on_report_button_pressed(object, type: String, button: ModCaseButton):
	if is_notifying:
		return
	
	evidence_viewer.hide()
	current_event_button = button
	
	if type == "msg":
		var newcase = object as ChatMessage
		
		message_viewer.load_message(newcase)
		current_event_chatlog = newcase.chatlog
		return
		
	if type == "case":
		var newcase = object as ModeratorCase
		message_viewer.load_mod_report(newcase)
		current_event_chatlog = newcase.chatlog
		return
		
	if type == "eve":
		var newcase = object as ChatroomEvent
		message_viewer.load_event(newcase)
		current_event_chatlog = newcase.chatlog
		return
	

func instantiate_button_for_case(newcase: ModeratorCase):
	var newbutton : ModCaseButton = event_button_scene.instantiate()
	newbutton.report = newcase
	
	if newbutton.report.case_owner == null:
		newbutton.assigned_msg_owner = MembersDatabase.get_random_member()
	else:
		newbutton.assigned_msg_owner = newbutton.report.case_owner

	if newbutton.report.report_target == null:
		newbutton.assigned_report_target = MembersDatabase.get_random_member([newbutton.assigned_msg_owner])
	else:
		newbutton.assigned_msg_owner = newbutton.report.report_target
			
	if newbutton.report.require_witness_count > 0:
		var chosen_witnesses = MembersDatabase.get_random_unique_members(newbutton.report.require_witness_count, [newbutton.assigned_msg_owner, newbutton.assigned_report_target])
		
		newbutton.assigned_witnesses = []
		
		for pattern in newbutton.report.require_witness_pattern:
			newbutton.assigned_witnesses.append(chosen_witnesses[pattern])
	
	today_event_button_container.add_child(newbutton)
	newbutton.request_show_event.connect(_on_report_button_pressed.bind())

func instantiate_button_for_msg(newmessage: ChatMessage):
	var newbutton : ModCaseButton = event_button_scene.instantiate()
	newbutton.message = newmessage
	
	if newbutton.message.speaker == null:
		newbutton.assigned_msg_owner = MembersDatabase.get_random_member()	
	
	today_event_button_container.add_child(newbutton)
	newbutton.request_show_event.connect(_on_report_button_pressed.bind())

func instantiate_button_for_event(new_event: ChatroomEvent):
	var newbutton : ModCaseButton = event_button_scene.instantiate()
	newbutton.event = new_event
	
	if newbutton.event.sender == null:
		newbutton.assigned_msg_owner = MembersDatabase.get_random_member()		
	
	today_event_button_container.add_child(newbutton)
	newbutton.request_show_event.connect(_on_report_button_pressed.bind())
	
func clear_daily_buttons():
	
	var skip_work = false
	
	for button in today_event_button_container.get_children():
		if button is ModCaseButton:
			if button.is_case:
				for consq : ModConsequence in button.report.ignore_consequences:
					consq.activate_consequence()
					
				if button.is_case:
					skip_work = true
					
			elif button.is_event:
				button.event.activate_default_consequence()
					
		button.queue_free()
		
	return skip_work


func _on_test_game_bg_request_change_panel(idx: int) -> void:	
	canvas_order.all(func(x):
		x.hide()
		return true
	)
	canvas_order.get(idx).show()

func _on_message_viewer_request_hide_me() -> void:
	current_event_button = null
	message_viewer.hide()
	evidence_viewer.hide()

const WIN_TEXT : String = "Your server has grown into a large, healthy community that treats people with respect."
const NORMAL_END_TEXT : String = "As the head moderator gave up on growing the server, one by one, the other moderators give up as well. Your server never grew large, but it's at least decent to be in."
const LOSE_TEXT : String = "Due to the toxic actions of the members and the poor atmosphere in general, the head moderator decides to delete the server and start a new one."
const NEW_DAY_TEXT : String = "Your action points have been recovered!"
const SKIP_WORK_TEXT : String = "Your action points have been recovered, but you didn't take care of all moderator reports. This may affect the server in some way... Let's try to do better today!"

const GAIN_MEMBER_TEXT : String = " The server has gained {new} new {member} while you were away."
const LOSE_MEMBER_TEXT : String = " The server has lost {new} {member} while you were away."

const WIN_TITLE: String = "Congratulations!"
const NORMAL_TITLE: String = "A Decent Server"
const LOSE_TITLE: String = "Game Over"
const NEW_DAY_TITLE: String = "New Day"
const SKIP_WORK_TITLE: String = "Whoops!"

const DEFAULT_CLOSE = "Close"
const BAD_CLOSE = "oh no"
const GOOD_CLOSE = "Yay!"
const RETURN_CLOSE = "Return to Main Menu"

const MEMBER_S = "Member"
const MEMBER_PL = "Members"

func show_good_ending():
	is_notifying = true
	notify_canvas.show()
	ending_rect.show()
	ending_rect.texture = good_end_bg
	game_end_panel.show_panel_with_text(WIN_TITLE, WIN_TEXT, RETURN_CLOSE)
	
func show_normal_ending():
	is_notifying = true
	notify_canvas.show()
	ending_rect.show()
	ending_rect.texture = normal_end_bg	
	game_end_panel.show_panel_with_text(NORMAL_TITLE, NORMAL_END_TEXT, RETURN_CLOSE)
	
func show_bad_ending():
	is_notifying = true
	notify_canvas.show()
	ending_rect.show()
	ending_rect.texture = bad_end_bg
	game_end_panel.show_panel_with_text(LOSE_TITLE, LOSE_TEXT, RETURN_CLOSE)	
	
func show_new_day(member_income : int):
	is_notifying = true
	notify_canvas.show()
	
	var bodytext = NEW_DAY_TEXT
	var plurality = MEMBER_S
	
	if member_income != 1 and member_income != -1:
		plurality = MEMBER_PL
	
	if member_income > 0:
		bodytext += GAIN_MEMBER_TEXT.format({"new": member_income, "member": plurality})
	elif member_income < 0:
		bodytext += LOSE_MEMBER_TEXT.format({"new": -1 * member_income, "member": plurality})	
	
	notif_panel.show_panel_with_text(NEW_DAY_TITLE, bodytext, DEFAULT_CLOSE)
	
func show_ignore_case_new_day(member_income : int):
	is_notifying = true
	notify_canvas.show()
	
	var bodytext = SKIP_WORK_TEXT
	var plurality = MEMBER_S
	
	if member_income != 1 and member_income != -1:
		plurality = MEMBER_PL
	
	if member_income > 0:
		bodytext += GAIN_MEMBER_TEXT.format({"new": member_income, "member": plurality})
	elif member_income < 0:
		bodytext += LOSE_MEMBER_TEXT.format({"new": -1 * member_income, "member": plurality})
		
	notif_panel.show_panel_with_text(SKIP_WORK_TITLE, bodytext, DEFAULT_CLOSE)
	
func show_consequence(consequence: ModConsequence):
	is_notifying = true
	notify_canvas.show()
	var close_text = DEFAULT_CLOSE
	
	if consequence.is_positive():
		close_text = GOOD_CLOSE
	else:
		close_text = BAD_CLOSE
	
	notif_panel.show_panel_with_text(consequence.notif_title, consequence.desc, close_text)

func _on_evidence_panel_hide_evidence_panel() -> void:
	message_viewer.show()

func _on_message_viewer_false_report() -> void:
	if is_notifying:
		return
	
	MainChatroom.remaining_actions_today -= 1
	
	current_event_button.apply_false_report_consq()
	show_consequence(current_event_button.report.false_report_consequences[0])
	
	clear_current_selected_event()
	
func _on_message_viewer_ignore() -> void:
	if is_notifying:
		return	
	
	current_event_button.apply_ignore_consequences()
	show_consequence(current_event_button.report.ignore_consequences[0])
	
	clear_current_selected_event()
	
func _on_message_viewer_kick_offender() -> void:
	if is_notifying:
		return	
	
	MainChatroom.remaining_actions_today -= 1
	
	current_event_button.apply_kick_consequences()
	show_consequence(current_event_button.report.kick_consequences[0])
	
	clear_current_selected_event()
	
func _on_message_viewer_warn_offender() -> void:
	if is_notifying:
		return	
	
	MainChatroom.remaining_actions_today -= 1
	
	current_event_button.apply_warn_consequences()
	show_consequence(current_event_button.report.warning_consequences[0])
	
	clear_current_selected_event()
	
func clear_current_selected_event():
	current_event_button.queue_free()
	message_viewer.hide()
	update_label()

func _on_message_viewer_event_option_chosen(idx: int) -> void:
	if is_notifying:
		return	
	
	var cost = current_event_button.event.option_cost[idx]
	if cost > 0:
		MainChatroom.remaining_actions_today -= cost
	
	current_event_button.event.activate_consequence(idx)
	show_consequence(current_event_button.event.get_first_consequence(idx))
	
	clear_current_selected_event()

func _on_rest_notif_trigger_close() -> void:
	end_day()

func _on_game_over_panel_trigger_close() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")

func _on_consequence_panel_trigger_close() -> void:
	is_notifying = false
	notify_canvas.hide()


func _on_option_button_pressed() -> void:
	is_notifying = true
	option_canvas.show()

func _on_option_close_button_pressed() -> void:
	is_notifying = false
	option_canvas.hide()


func _on_return_to_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")


func _on_message_viewer_request_evidence() -> void:
	message_viewer.hide()
	evidence_viewer.show()
	
	evidence_viewer.load_chatlog(current_event_button.get_event_name(), current_event_chatlog, current_event_button.assigned_msg_owner, current_event_button.assigned_report_target, current_event_button.assigned_witnesses)


func _on_bgm_vol_slider_value_changed(value: float) -> void:
	GameOptions.save_bgm_volume(value)	
	set_current_bgm()
