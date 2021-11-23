# DesiredType that can be saved in disk like a custom resource. 
# Used as [Shared Variables] so that the data it holds can be accessed and modified from multiple 
# parts of the code. Based on the idea of Unity's Scriptable Objects and Ryan Hipple's Unite Talk.
# @category: Shared Variables
tool
# class_name DesiredTypeVariable # search and replace DesiredType to create your SharedVariable.
extends SharedVariable

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------

# Shared Variable value
var value: DesiredType = DEFAULTDesiredType setget _set_value, _get_value

# Defautl value in case you're using `is_session_only`
var default_value: DesiredType = DEFAULTDesiredType setget _set_default_value, _get_default_value

#--- private variables - order: export > normal var > onready -------------------------------------

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

func _get_property_list() -> Array:
	var properties: = []
	
	if is_session_only:
		if not has_meta("default_value"):
			set_meta("default_value", _get_value())
		properties.append(_get_value_property_dict("default_value"))
	else:
		if has_meta("default_value"):
			set_meta("value", _get_default_value())
			set_meta("default_value", null)
		properties.append(_get_value_property_dict("value"))
	
	return properties


func is_class(p_class: String) -> bool:
	return p_class == "DesiredTypeVariable" or .is_class(p_class)


func get_class() -> String:
	return "DesiredTypeVariable"

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _get_value_property_dict(property_name: String) -> Dictionary:
	var dict = {
		name = "%s"%[property_name],
		# Pay attention to this though, it has to be UPPERCASE, and if it's a custom type, 
		# probably TYPE_OBJECT
		type = TYPE_DESIREDTYPE, 
		usage = PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE,
		hint = PROPERTY_HINT_NONE,
	}
	return dict


func _set_value(p_value: DesiredType) -> void:
	if _should_reset_value():
		p_value = get_meta("default_value")
	set_meta("value", p_value)
	value = p_value
	emit_signal("value_updated")
	_auto_save()


func _get_value() -> DesiredType:
	var meta_value = DEFAULTDesiredType
	if _should_reset_value():
		meta_value = get_meta("default_value")
		_set_value(meta_value)
	elif value == DEFAULTDesiredType and has_meta("value"):
		meta_value = get_meta("value")
	else:
		meta_value = value
	return meta_value


func _set_default_value(p_value: DesiredType) -> void:
	set_meta("default_value", p_value)
	_set_value(p_value)
	default_value = p_value
	_auto_save(true)


func _get_default_value() -> DesiredType:
	var meta_value = DEFAULTDesiredType
	if default_value == DEFAULTDesiredType and has_meta("default_value"):
		meta_value = get_meta("default_value")
	else:
		meta_value = default_value
	return meta_value

### -----------------------------------------------------------------------------------------------
