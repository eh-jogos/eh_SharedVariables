# Array of [StringVariable] that can be saved in disk like a custom resource. 
# Used as [Shared Variables] so that the data it holds can be accessed and modified from multiple 
# parts of the code. Based on the idea of Unity's Scriptable Objects and Ryan Hipple's Unite Talk.
# @category: Shared Variables
tool
class_name StringVariableArray
extends SharedVariable

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------

# Shared Variable value
var value: Array = [] setget _set_value, _get_value

# Defautl value in case you're using `is_session_only`
var default_value: Array = [] setget _set_default_value, _get_default_value

#--- private variables - order: export > normal var > onready -------------------------------------

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

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
	return p_class == "StringVariableArray" or .is_class(p_class)


func get_class() -> String:
	return "StringVariableArray"

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

func append(element) -> void:
	var string_variable: StringVariable = null
	if not is_instance_valid(element) or not (element is String or element is StringVariable):
		push_error("StringVariableArray only accepts StringVariables as elements")
		return
	
	if element is String:
		string_variable = StringVariable.new()
		string_variable.value = element
	elif element is StringVariable:
		string_variable = element
	
	string_variable.connect_to(self, "_on_array_element_updated")
	
	value.push_back(string_variable)
	
	emit_signal("value_updated")
	_auto_save()


func erase(element: StringVariable) -> void:
	if value.has(element):
		value.erase(element)
	
	emit_signal("value_updated")
	_auto_save()


func get_string_array() -> Array:
	var array: = []
	for string_variable in value:
		array.push_back(string_variable.value)
	return array

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _get_value_property_dict(property_name: String) -> Dictionary:
	var dict = {
		name = "%s"%[property_name],
		type = TYPE_ARRAY, 
		usage = PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE,
		hint = PROPERTY_HINT_RESOURCE_TYPE,
	}
	return dict


func _handle_new_data(old_array: Array, new_array: Array) -> void:
	for idx in range(old_array.size()-1, -1, -1):
		var element = old_array[idx]
		if new_array.has(element):
			var index = new_array.find(element)
			new_array.remove(index)
		else:
			old_array.remove(idx)


func _get_treated_value(from_value: Array, to_value: Array) -> Array:
	var treated_value: = from_value.duplicate()
	
	_handle_new_data(treated_value, to_value)
	
	for element in to_value:
		if element is StringVariable:
			treated_value.append(element)
		elif element is String:
			var new_string_variable = StringVariable.new()
			new_string_variable.value = element
			treated_value.append(new_string_variable)
	
	return treated_value


func _set_value(p_value: Array) -> void:
	if _should_reset_value():
		p_value = get_meta("default_value")
	
	value = _get_treated_value(value, p_value)
	set_meta("value", value)
	
	emit_signal("value_updated")
	_auto_save()


func _get_value() -> Array:
	var meta_value = []
	if _should_reset_value():
		meta_value = get_meta("default_value")
		_set_value(meta_value)
	elif value.empty() and has_meta("value"):
		meta_value = get_meta("value")
	else:
		meta_value = value
	
	for element in value:
		var string_variable: StringVariable = element
		string_variable.connect_to(self, "_on_array_element_updated")
	
	return meta_value


func _set_default_value(p_value: Array) -> void:
	default_value = _get_treated_value(default_value, p_value)
	set_meta("default_value", default_value)
	_set_value(default_value)
	
	_auto_save(true)


func _get_default_value() -> Array:
	var meta_value = []
	if default_value.empty() and has_meta("default_value"):
		meta_value = get_meta("default_value")
	else:
		meta_value = default_value
	
	for element in value:
		var string_variable: StringVariable = element
		string_variable.connect_to(self, "_on_array_element_updated")
	
	return meta_value


func _on_array_element_updated() -> void:
	_auto_save()
	emit_signal("value_updated")

### -----------------------------------------------------------------------------------------------
