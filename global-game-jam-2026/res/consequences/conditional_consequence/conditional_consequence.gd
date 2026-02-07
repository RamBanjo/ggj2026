extends ModConsequence
class_name ConditionalConsequence

@export var conditional_list : Array[Conditional] = []

func is_valid():
	for cond in conditional_list:
		if not cond.test_conditional():
			return false
	return true

@export var fail_title : String = "As a result of your actions..."
@export_multiline var fail_desc : String
@export var fail_positive : bool
@export var fail_negative : bool
@export var consequence_if_fail : Array[ConsequenceEffect]

func activate_consequence():
	if is_valid():
		super.activate_consequence()
	else:
		for consq in consequence_if_fail:
			consq.activate_consequence()

func get_consequence_title():
	if is_valid():
		return super.get_consequence_title()
	else:
		return fail_title
		
func get_consequence_description():
	if is_valid():
		return super.get_consequence_description()
	else:
		return fail_desc
		
func get_positiveness():
	if is_valid():
		return super.get_positiveness()
	else:
		return fail_positive

func get_negativeness():
	if is_valid():
		return super.get_negativeness()
	else:
		return fail_negative
		
func is_inbox_spawn():
	if is_valid():
		return super.is_inbox_spawn()
	else:
		for consq in consequence_if_fail:
			if consq.is_inbox_spawn():
				return true
		return false
