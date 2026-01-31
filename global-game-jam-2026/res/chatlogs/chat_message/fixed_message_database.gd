extends Resource
class_name FixedMessageDatabase

static var message_list : Dictionary

const MESSAGE_DIR = "res://res/chatlogs/chat_message/fixed/"

static func initialize_messages():
	var msg_dir = DirAccess.open(MESSAGE_DIR)
	if msg_dir != null:
		msg_dir.list_dir_begin()
		var file_name = msg_dir.get_next()
		
		while file_name != "":
			var full_path = MESSAGE_DIR + "/" + file_name
			var new_msg : ChatMessage = load(full_path)
			message_list[new_msg.internal_id] = new_msg
			file_name = msg_dir.get_next()
			
	print("load fixed messages: ", len(message_list))		
	
