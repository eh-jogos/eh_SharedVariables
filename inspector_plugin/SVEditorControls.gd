# Write your doc string for this file here
tool
class_name SVEditorControls
extends Node

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------

export var properties_to_expose: PoolStringArray = [] setget _set_properties_to_expose

#--- private variables - order: export > normal var > onready -------------------------------------

onready var _inspector_helper: = SharedInspector.new(get_parent(), properties_to_expose)

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _ready() -> void:
	for property in properties_to_expose:
		_set("_%s"%[property], get_parent().get_meta(property))
	
	if not Engine.editor_hint:
		queue_free()
	
	update_configuration_warning()


func _set(property: String, value) -> bool:
	var has_handled: = false
	if _inspector_helper == null:
		return has_handled
	
	has_handled = _inspector_helper._set(property, value)
	return has_handled


func _get(property: String):
	var to_return = null
	if _inspector_helper == null:
		return to_return
	
	to_return = _inspector_helper._get(property)
	return to_return


func _get_property_list() -> Array:
	if _inspector_helper == null:
		return []
	
	var properties: Array = _inspector_helper._get_property_list()
	return properties


func _get_configuration_warning() -> String:
	var msg: = ""
	
	if get_parent() == null or get_parent().get_script() == null:
		msg = "This node only works as a child of another node that has a script, and that script "\
				+ "must have variables of types that extend from SharedVariables and must be a tool."
	elif not get_parent().get_script().is_tool():
		msg = "Parent must be a tool script for the exported variables to work."
	
	return msg

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _set_properties_to_expose(value: PoolStringArray) -> void:
	properties_to_expose = value
	if get_parent() != null:
		_inspector_helper = SharedInspector.new(get_parent(), properties_to_expose)
		property_list_changed_notify()

### -----------------------------------------------------------------------------------------------
