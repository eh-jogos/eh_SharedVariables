# NodePath that can be saved in disk like a custom resource.
# Used as [Shared Variables] so that the data it holds can be accessed and modified from multiple 
# parts of the code. Based on the idea of Unity's Scriptable Objects and Ryan Hipple's Unite Talk.
# @category: Shared Variables
class_name NodePathVariable
extends SharedVariable

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------

# Shared Variable value
var value: NodePath = NodePath("") setget _set_value, _get_value

#--- private variables - order: export > normal var > onready -------------------------------------

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _init() -> void:
	is_session_only = true


func _get_property_list() -> Array:
	var properties: = []
	
	return properties


func is_class(p_class: String) -> bool:
	return p_class == "NodePathVariable" or .is_class(p_class)


func get_class() -> String:
	return "NodePathVariable"

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _set_value(p_value: NodePath) -> void:
	if is_first_run_in_session:
		is_first_run_in_session = false
	
	value = p_value
	emit_signal("value_updated")
	_auto_save()


func _get_value() -> NodePath:
	var default_value = NodePath("")
	if _should_reset_value():
		_set_value(default_value)
	
	return value


func _set_is_session_only(value: bool) -> void:
	if not value:
		value = true
		var msg: = "NodePathVariable's are always session only. To understand how to use it and "
		msg += "see code examples see the Documentation or use the custom Node eh_NodePathListener"
		push_warning(msg)
	._set_is_session_only(value)

### -----------------------------------------------------------------------------------------------
