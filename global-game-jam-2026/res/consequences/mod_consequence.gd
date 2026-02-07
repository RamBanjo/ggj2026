extends Resource
class_name ModConsequence

@export var notif_title : String = "As a result of your actions..."
@export_multiline var desc : String
@export var consq_effects : Array[ConsequenceEffect]
@export var is_positive : bool
@export var is_negative : bool

func is_valid():
	return true

func activate_consequence():
	for effect in consq_effects:
		effect.activate_consequence()

func get_consequence_title():
	return notif_title

func get_consequence_description():
	return desc

func get_positiveness():
	return is_positive
	
func get_negativeness():
	return is_negative
	
func is_inbox_spawn():
	for consq in consq_effects:
		if consq.is_inbox_spawn():
			return true
			
	return false
