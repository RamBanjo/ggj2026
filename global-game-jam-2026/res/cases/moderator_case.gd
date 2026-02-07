extends Resource
class_name ModeratorCase

##The internal ID of the case.
@export var case_id : String

##The display name of the case.
@export var case_display_name: String

##The character who is doing the reporting. For random cases, a random chat member will be generated.
@export var case_owner : ChatMember

##The description of the case. For random cases, the case owner will use the default report message.
@export_multiline var case_description: String

##Chatlogs attached to the case.
@export var chatlog : Chatlog

##The character being reported. For random cases, a random chat member will be generated.
@export var report_target : ChatMember

##Consequence for ignoring this. 
@export var ignore_consequences : ModConsequence

##Consequence for giving out warning.
@export var warning_consequences: ModConsequence

##Consequence for kicking.
@export var kick_consequences: ModConsequence

##Consequence for false_reporting.
@export var false_report_consequences: ModConsequence

#Booleans that exist to categorize quests.
@export var is_false_report : bool
@export var is_spammer : bool
@export var is_extreme : bool

##If a case is unique, it only shows up once per entire run and will not appear again after it's been resolved.
@export var is_unique : bool

#A random witness will be assigned if not blank. For each unique number an array of witness will be created.
@export var require_witness_count : int
@export var require_witness_pattern : PackedInt32Array

##For random quests, this quest will only appear if all conditionals listed here are met.
@export var conditionals : Array[Conditional]

func can_spawn():
	for cond in conditionals:
		if not cond.test_conditional():
			return false
			
	return true
