# Base SharedVariable type, should never be used directly, it just defines some commom interface 
# for all [Shared Variables].
# The intent of [Shared Variables] are so that the data it holds can be saved to disk as a resource
# and loaded, accessed and modified from multiple parts of the code. 
# Based on the idea of Unity's Scriptable Objects and Ryan Hipple's Unite Talk.
# @category: Shared Variables
class_name SharedVariable
extends Resource

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

# Signal emitted when the Variable's value is updated.
signal value_updated

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------

export var is_session_only: bool = false setget _set_is_session_only

var is_first_run_in_session: bool = true

#--- private variables - order: export > normal var > onready -------------------------------------

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

static func get_property_category() -> Dictionary:
	var dict = {
		name = "Shared Variables",
		type = TYPE_NIL,
		usage = PROPERTY_USAGE_CATEGORY,
	}
	return dict


static func get_property_dict(property_name: String, hint_string: String) -> Dictionary:
	var dict = {
		name = "%s"%[property_name],
		type = TYPE_OBJECT,
		usage = PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE,
		hint = PROPERTY_HINT_RESOURCE_TYPE,
		hint_string = "%s"%[hint_string]
	}
	return dict


static func get_properties_for(names: PoolStringArray, hint_strings: Dictionary) ->  Array:
	var properties: = []
	properties.append(get_property_category())
	for name in names:
		var hint_string = "SharedVariable"
		if hint_strings.has(name) and hint_strings[name] != "Resource":
			hint_string = hint_strings[name]
		properties.append(get_property_dict(name, hint_string))
	return properties


func is_class(p_class: String) -> bool:
	return p_class == "SharedVariable" or .is_class(p_class)


func get_class() -> String:
	return "SharedVariable"

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

func connect_to(object: Object, func_name: String) -> void:
	if not is_connected("value_updated", object, func_name):
		connect("value_updated", object, func_name)


func disconnect_from(object: Object, func_name: String) -> void:
	if is_connected("value_updated", object, func_name):
		disconnect("value_updated", object, func_name)


func get_dict(instance: Object = self) -> Dictionary:
	var dict = eh_Serializer.get_dict_from(instance)
	return dict


func load_dict(dict: Dictionary, instance: Object = self) -> bool:
	var success: = eh_Serializer.load_dict_into(dict, instance)
	
	if success:
		emit_signal("value_updated")
		_auto_save()
	
	return success

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _auto_save(force_save = not is_session_only) -> void:
	if (force_save or Engine.editor_hint) and resource_path != "":
		var treated_path: = _treat_resource_path()
		var instance_to_save = self
		if treated_path != resource_path:
			instance_to_save = load(treated_path)
		var error = ResourceSaver.save(treated_path, instance_to_save)
		if error != OK:
			push_error("ERROR %s | %s"%[error, treated_path])


func _treat_resource_path() -> String:
	var treated_path: = resource_path
	var subresource_marker: = resource_path.find("::")
	if  subresource_marker != -1:
		treated_path = resource_path.substr(0, subresource_marker)
	return treated_path


func _should_reset_value() -> bool:
	var should_reset = is_first_run_in_session and is_session_only
	is_first_run_in_session = false
	return should_reset


func _set_is_session_only(value: bool) -> void:
	is_session_only = value
	property_list_changed_notify()
	_auto_save()

### -----------------------------------------------------------------------------------------------
