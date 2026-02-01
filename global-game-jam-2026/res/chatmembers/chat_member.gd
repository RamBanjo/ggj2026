extends Resource
class_name ChatMember

@export var internal_id : String
@export var display_name: String
@export var profile_picture: Texture2D
@export_multiline var profile_desc : String = "do_not_show"
@export_multiline var default_report_msg : String

func can_show_profile():
	return profile_desc != "do_not_show"
