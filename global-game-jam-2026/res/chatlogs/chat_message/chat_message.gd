extends Resource
class_name ChatMessage

@export var internal_id : String
@export var speaker : ChatMember
@export var title : String
@export var chatlog : Chatlog
@export_multiline var text : String
