extends Resource
class_name FixedMessageDatabase

static var message_list : Dictionary
static var random_msg : Array[ChatMessage]

const MESSAGE_PATH = "res://res/chatlogs/chat_message/fixed"
const RANDMSG_PATH = "res://res/chatlogs/chat_message/random"

static func initialize_messages():
	var msg_dir = DirAccess.open(MESSAGE_PATH)
	if msg_dir != null:
		msg_dir.list_dir_begin()
		var file_name = msg_dir.get_next()
		
		while file_name != "":
			var full_path = MESSAGE_PATH + "/" + file_name
			var new_msg : ChatMessage = load(full_path)
			message_list[new_msg.internal_id] = new_msg
			file_name = msg_dir.get_next()

	var randmsgdir = DirAccess.open(RANDMSG_PATH)
	if randmsgdir != null:
		randmsgdir.list_dir_begin()
		var file_name = randmsgdir.get_next()
		
		while file_name != "":
			var full_path = RANDMSG_PATH + "/" + file_name
			var new_msg : ChatMessage = load(full_path)
			random_msg.append(new_msg)
			file_name = msg_dir.get_next()
						
	print("load random messages: ", len(random_msg))
	
static func get_random_msg():
	return random_msg[randi() % len(random_msg)]
	
