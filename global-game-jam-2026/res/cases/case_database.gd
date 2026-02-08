extends Resource
class_name CaseDatabase

static var fixed_cases : Dictionary
static var random_cases : Array[ModeratorCase]

const FIXED_CASE_PATH = "res://res/cases/fixed"
const RANDOM_CASE_PATH = "res://res/cases/random"

static func initialize_cases():
	var fixed_case_dir = DirAccess.open(FIXED_CASE_PATH)
	if fixed_case_dir != null:
		fixed_case_dir.list_dir_begin()
		var file_name = fixed_case_dir.get_next()
		if '.tres.remap' in file_name:
			file_name = file_name.trim_suffix('.remap')
					
		while file_name != "":
			var full_path = FIXED_CASE_PATH + "/" + file_name
			var new_case : ModeratorCase = load(full_path)
			fixed_cases[new_case.case_id] = new_case
			file_name = fixed_case_dir.get_next()
			if '.tres.remap' in file_name:
				file_name = file_name.trim_suffix('.remap')
			
	print("loaded fixed cases: ", len(fixed_cases))
			
	var random_case_dir = DirAccess.open(RANDOM_CASE_PATH)
	if random_case_dir != null:
		random_case_dir.list_dir_begin()
		var file_name = random_case_dir.get_next()
		if '.tres.remap' in file_name:
			file_name = file_name.trim_suffix('.remap')
					
		while file_name != "":
			var full_path = RANDOM_CASE_PATH + "/" + file_name
			var new_case : ModeratorCase = load(full_path)
			random_cases.append(new_case)
			file_name = random_case_dir.get_next()
			if '.tres.remap' in file_name:
				file_name = file_name.trim_suffix('.remap')			
	print("load random cases: ", len(random_cases))

static var cases_seen_today : PackedStringArray = []
static var unique_cases_seen_this_run : PackedStringArray = []

static func reset_today_seen_cases():
	cases_seen_today = []
	
static func reset_unique_cases_seen_this_run():
	unique_cases_seen_this_run = []
	
static func make_list_of_unseen_cases():
	return random_cases.filter(func(x : ModeratorCase):
		
		return x.case_id not in cases_seen_today and x.case_id not in unique_cases_seen_this_run and x.can_spawn()
		)

static func default_nonexttreme_filter(x: ModeratorCase):
	return not x.is_extreme

static func get_random_case(filter: Callable = default_nonexttreme_filter):
	
	var unseen_cases = make_list_of_unseen_cases().filter(filter)
	
	var selected_case = unseen_cases[randi() % len(unseen_cases)]
	cases_seen_today.append(selected_case.case_id)
	
	if selected_case.is_unique:
		unique_cases_seen_this_run.append(selected_case.case_id)
	
	return selected_case
	
static func get_random_legit():
	return get_random_case().filter(func(x: ModeratorCase):
		return not x.is_false_report
		)
	
static func get_random_false():
	return get_random_case().filter(func(x: ModeratorCase):
		return x.is_false_report
		)

static func get_random_spammer():
	return get_random_case().filter(func(x: ModeratorCase):
		return x.is_spammer
		)

static func get_random_extreme():
	return get_random_case(func(x):
		return x.is_extreme
		)
	
