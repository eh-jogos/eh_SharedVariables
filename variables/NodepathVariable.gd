# NodePath that can be saved in disk like a custom resource.
# Used as [Shared Variables] so that the data it holds can be accessed and modified from multiple 
# parts of the code. Based on the idea of Unity's Scriptable Objects and Ryan Hipple's Unite Talk.
# @category: Shared Variables
tool
class_name NodePathVariable
extends SharedVariable

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------

# Shared Variable value
var value: NodePath = NodePath("") setget _set_value, _get_value

# Defautl value in case you're using `is_session_only`
var default_value = NodePath("")

#--- private variables - order: export > normal var > onready -------------------------------------

var _followers: = {}

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

func is_empty() -> bool:
	return value == NodePath("")


func add_follower(object: Node, variable_name: String) -> void:
	if eh_EditorHelpers.is_editor():
		return
	
	_followers[object] = variable_name
	if not is_empty():
		object.set(variable_name, object.get_node(value))


func remove_follower(object: Object) -> void:
	if eh_EditorHelpers.is_editor():
		return
	
	if _followers.has(object):
		_followers.erase(object)

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _set_value(p_value: NodePath) -> void:
	if is_first_run_in_session:
		is_first_run_in_session = false
	
	var has_changed: = p_value != value
	value = p_value
	emit_signal("value_updated")
	
	if has_changed:
		_update_all_followers()
	
	_auto_save()


func _get_value() -> NodePath:
	if _should_reset_value():
		_set_value(default_value)
	
	return value


func _set_is_session_only(value: bool) -> void:
	if not value:
		value = true
		var msg: = "NodePathVariable's are always session only. To understand how to use it and "
		msg += "see code examples see the Documentation or use the custom Node eh_NodePathSetter"
		push_warning(msg)
	._set_is_session_only(value)


func _update_all_followers() -> void:
	if eh_EditorHelpers.is_editor():
		return
	
	for object in _followers:
		if is_instance_valid(object):
			object.set(_followers[object], object.get_node_or_null(value))
		else:
			_followers.erase(object)

### -----------------------------------------------------------------------------------------------
