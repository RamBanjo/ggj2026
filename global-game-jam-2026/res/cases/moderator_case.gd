extends Resource
class_name ModeratorCase

##The internal ID of the case.
@export var case_id : String

##The display name of the case.
@export var case_display_name: String

##The character who is doing the reporting. For random cases, a random chat member will be generated.
@export var case_owner : ChatMember

##The description of the case. For random cases, the case owner will use the default report message.
@export var case_description: String

##Chatlogs attached to the case.
@export var chatlog : Array[Chatlog]

##The character being reported. For random cases, a random chat member will be generated.
@export var report_target : ChatMember
