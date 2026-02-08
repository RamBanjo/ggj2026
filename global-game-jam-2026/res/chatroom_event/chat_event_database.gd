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
			
static func get_random_event():
	
	var filtered_list = rand_event.filter(func(x : ChatroomEvent):
		return x.can_spawn()
		)
	
	return filtered_list[randi() % len(filtered_list)] as ChatroomEvent
