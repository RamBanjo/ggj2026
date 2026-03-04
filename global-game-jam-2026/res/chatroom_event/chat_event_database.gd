extends Resource
class_name ChatEventDatabase

static var fixed_event : Dictionary
static var rand_event : Array[ChatroomEvent]

const FIXED_EVENT_PATH = "res://res/chatroom_event/fixed"
const RAND_EVENT_PATH = "res://res/chatroom_event/random"

static func initialize_events():
	var fixed_case_dir = DirAccess.open(FIXED_EVENT_PATH)
	if fixed_case_dir != null:
		fixed_case_dir.list_dir_begin()
		var file_name = fixed_case_dir.get_next()

		if '.tres.remap' in file_name:
			file_name = file_name.trim_suffix('.remap')		
		
		while file_name != "":
			var full_path = FIXED_EVENT_PATH + "/" + file_name
			var new_case : ChatroomEvent = load(full_path)
			fixed_event[new_case.internal_id] = new_case
			file_name = fixed_case_dir.get_next()
			if '.tres.remap' in file_name:
				file_name = file_name.trim_suffix('.remap')
			
	print("loaded fixed events: ", len(fixed_event))
			
	var random_case_dir = DirAccess.open(RAND_EVENT_PATH)
	if random_case_dir != null:
		random_case_dir.list_dir_begin()
		var file_name = random_case_dir.get_next()
		if '.tres.remap' in file_name:
			file_name = file_name.trim_suffix('.remap')		
		while file_name != "":
			var full_path = RAND_EVENT_PATH + "/" + file_name
			var new_case : ChatroomEvent = load(full_path)
			rand_event.append(new_case)
			file_name = random_case_dir.get_next()
			if '.tres.remap' in file_name:
				file_name = file_name.trim_suffix('.remap')
	print("load random events: ", len(rand_event))

static var events_today : PackedStringArray = []
static var events_yesterday : PackedStringArray = []

static func reset_today_seen_events(startup: bool = false):
	
	if startup:
		events_today = []
	
	events_yesterday = []
	events_yesterday.append_array(events_today)
	events_today = []

static func get_events_banlist():
	var banlist : PackedStringArray = []
	
	banlist.append_array(events_yesterday)
	banlist.append_array(events_today)
	
	return banlist

static func get_random_event():
	
	var filtered_list = rand_event.filter(func(x : ChatroomEvent):
		return x.can_spawn() and x.internal_id not in get_events_banlist()
		)
	
	var chosen_event : ChatroomEvent = filtered_list[randi() % len(filtered_list)] as ChatroomEvent
	events_today.append(chosen_event.internal_id)
	
	return chosen_event
