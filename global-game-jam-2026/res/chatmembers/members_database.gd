extends Resource
class_name MembersDatabase

static var members_list : Array[ChatMember] = []

const MEMBER_PATH = "res://res/chatmembers/random_members/"

static func initialize_random_members():
	var randmem_dir = DirAccess.open(MEMBER_PATH)
	if randmem_dir != null:
		randmem_dir.list_dir_begin()
		var file_name = randmem_dir.get_next()
		
		while file_name != "":
			var full_path = MEMBER_PATH + "/" + file_name
			var new_case : ChatMember = load(full_path)
			members_list.append(new_case)
			file_name = randmem_dir.get_next()
			
	print("load random members: ", len(members_list))

static var seen_members_today : Array = []
static func reset_seen_members():
	seen_members_today = []
	

static func get_random_member(exclusion: Array = []) -> ChatMember:
	
	var exclusion_plus_seen_today = []
	exclusion_plus_seen_today.append_array(seen_members_today)
	exclusion_plus_seen_today.append_array(exclusion)
	
	var choose_list = members_list.filter(func(x):
		return x not in exclusion_plus_seen_today
		)
	
	var chosen = choose_list[randi() % len(choose_list)] as ChatMember
	seen_members_today.append(chosen)
	return chosen
	
static func get_random_unique_members(n: int, exclusion : Array[ChatMember] = []):
	var return_list = []
	
	#var current_exclusion : Array = []
	#current_exclusion.append_array(exclusion)
	
	for i in n:
		var new_mem = get_random_member(exclusion)
		return_list.append(new_mem)
		#current_exclusion.append(new_mem)
		
	return return_list
	
