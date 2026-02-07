extends VBoxContainer
class_name MemberAddress

##TODO: You can click the profile picture to view the profile, maybe
@export var title : String = "A Concerned Member"
@export var member : ChatMember

@onready var title_label : Label = $Title
@onready var name_label : Label = $HBoxContainer/Name
@onready var picture : TextureRect = $HBoxContainer/PFP

func _ready() -> void:
	title_label.text = title
	
	if member != null:
		name_label.text = member.display_name
		picture.texture = member.profile_picture

func update_member(new_mem : ChatMember, newtitle : String = ""):
	
	title_label.hide()
	
	if newtitle != "":
		title_label.show()	
		title_label.text = newtitle
	
	member = new_mem 
	update_member_name_and_display()
	
func update_member_name_and_display():
	if member != null:
		name_label.text = member.display_name
		picture.texture = member.profile_picture	


signal request_profile_panel
func _pfp_clicked() -> void:
	request_profile_panel.emit(member)
