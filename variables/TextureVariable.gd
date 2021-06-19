# Texture that can be saved in disk like a custom resource. 
# Used as [Shared Variables] so that the data it holds can be accessed and modified from multiple 
# parts of the code. Based on the idea of Unity's Scriptable Objects and Ryan Hipple's Unite Talk.
# @category: Shared Variables
tool
class_name TextureVariable
extends SharedVariable

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------

# Shared Variable value
var value: Texture = null setget _set_value, _get_value

# Defautl value in case you're using `is_session_only`
var default_value: Texture = null

#--- private variables - order: export > normal var > onready -------------------------------------

# Dictionary of followers that should be updated whenever value changes.
# Its format is: {Object: String (name of variable that should be updated in Object), ...}
var _followers: Dictionary = {}

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _init() -> void:
	is_session_only = true


func _get_property_list() -> Array:
	var properties: = []
	
	properties.append({
		name = "preview",
		type = TYPE_OBJECT, 
		usage = PROPERTY_USAGE_EDITOR,
		hint = PROPERTY_HINT_RESOURCE_TYPE,
		hint_string = "Texture"
	})
	
	return properties


func _get(property: String):
	if property == "preview":
		return value


func is_class(p_class: String) -> bool:
	return p_class == "TextureVariable" or .is_class(p_class)


func get_class() -> String:
	return "TextureVariable"

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

func is_empty() -> bool:
	return value == null


func add_follower(object: Object, variable_name: String) -> void:
	_followers[object] = variable_name
	if not is_empty():
		object.set(variable_name, value)


func remove_follower(object: Object) -> void:
	if _followers.has(object):
		_followers.erase(object)

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _set_value(p_value: Texture) -> void:
	if is_first_run_in_session:
		is_first_run_in_session = false
	
	var has_changed: = p_value != value
	value = p_value
	emit_signal("value_updated")
	
	if has_changed:
		_update_all_followers()

func _get_value() -> Texture:
	if _should_reset_value():
		_set_value(default_value)
	
	return value


func _set_is_session_only(value: bool) -> void:
	if not value:
		value = true
		var msg: = "TextureVariable's are always session only. They are meant to be used as a way "
		msg += "of fowarding a 'ViewportTexture' to distant Nodes or nodes in other scenes."
		msg += "To understand how to use it and see code examples see the Documentation or use "
		msg += "the custom Node eh_TextureSetter"
		push_warning(msg)
	._set_is_session_only(value)


func _update_all_followers() -> void:
	for object in _followers:
		if is_instance_valid(object):
			object.set(_followers[object], value)
		else:
			_followers.erase(object)

### -----------------------------------------------------------------------------------------------
