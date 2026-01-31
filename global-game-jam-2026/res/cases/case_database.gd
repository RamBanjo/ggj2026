extends Resource
class_name CaseDatabase

static var fixed_cases : Dictionary
static var random_cases : Array[ModeratorCase]

const FIXED_CASE_DIR = "res://res/cases/fixed"
const RANDOM_CASE_DIR = "res://res/cases/random"

static func initialize_cases():
	var fixed_case_dir = DirAccess.open(FIXED_CASE_DIR)
	if fixed_case_dir != null:
		fixed_case_dir.list_dir_begin()
		var file_name = fixed_case_dir.get_next()
		
		while file_name != "":
			var full_path = FIXED_CASE_DIR + "/" + file_name
			var new_case : ModeratorCase = load(full_path)
			fixed_cases[new_case.case_id] = new_case
			file_name = fixed_case_dir.get_next()
			
	print("loaded fixed cases: ", len(fixed_cases))
			
	var random_case_dir = DirAccess.open(RANDOM_CASE_DIR)
	if random_case_dir != null:
		random_case_dir.list_dir_begin()
		var file_name = random_case_dir.get_next()
		
		while file_name != "":
			var full_path = RANDOM_CASE_DIR + "/" + file_name
			var new_case : ModeratorCase = load(full_path)
			random_cases.append(new_case)
			file_name = random_case_dir.get_next()
			
	print("load random cases: ", len(random_cases))
			
static func get_random_case():
	return random_cases[randi() % len(random_cases)]
	
static func get_random_legit():
	var legit_cases = random_cases.filter(func(x: ModeratorCase):
		return not x.is_false_report
		)
	
	return legit_cases[randi() % len(legit_cases)]
	
static func get_random_false():
	var legit_cases = random_cases.filter(func(x: ModeratorCase):
		return x.is_false_report
		)
	
	return legit_cases[randi() % len(legit_cases)]	

static func get_random_spammer():
	var legit_cases = random_cases.filter(func(x: ModeratorCase):
		return x.is_spammer
		)
	
	return legit_cases[randi() % len(legit_cases)]	
