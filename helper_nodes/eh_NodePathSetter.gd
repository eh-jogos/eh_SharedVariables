# Write your doc string for this file here
tool
class_name eh_NodePathSetter
extends Node

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------

#--- private variables - order: export > normal var > onready -------------------------------------

var _nodepath_variable: NodePathVariable = null

var _custom_editor: = eh_CustomInspector.new(
		self, 
		["_nodepath_variable"],
		""
)

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _enter_tree() -> void:
	if eh_EditorHelpers.is_editor():
		eh_EditorHelpers.disable_all_processing(self)
		return
	
	_custom_editor.set_source_properties()
	if _nodepath_variable != null:
		_nodepath_variable.value = get_parent().get_path()


func _exit_tree() -> void:
	if eh_EditorHelpers.is_editor():
		return
	
	if _nodepath_variable != null and _nodepath_variable.value == get_parent().get_path():
		_nodepath_variable.reset()


func _get_property_list() -> Array:
	var properties = _custom_editor._get_property_list()
	return properties


func _set(property: String, value) -> bool:
	var has_handled: bool = _custom_editor._set(property, value)
	
	if has_handled:
		update_configuration_warning()
	
	return has_handled


func _get(property: String):
	return _custom_editor._get(property)


func _get_configuration_warning() -> String:
	var msg: = ""
	
	if _nodepath_variable == null:
		msg = "You must set a NodePathVariable resource in the editor for this node to work"
	
	return msg

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

### -----------------------------------------------------------------------------------------------
