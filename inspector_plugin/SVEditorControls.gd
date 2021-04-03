# Write your doc string for this file here
tool
class_name SVEditorControls
extends Node

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

const EXPORT_TOKEN = "#sv-export"

#--- public variables - order: export > normal var > onready --------------------------------------


#--- private variables - order: export > normal var > onready -------------------------------------

var _properties_to_expose: PoolStringArray = []

var _inspector_helper: SharedInspector

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _ready() -> void:
	update_properties_to_expose()
	
	for property in _properties_to_expose:
		_set("_%s"%[property], get_meta(property))
	
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

func update_properties_to_expose() -> void:
	_properties_to_expose = []
	var script: GDScript = get_parent().get_script()
	var export_comment_begin = script.source_code.find(EXPORT_TOKEN)
	while export_comment_begin != -1:
		var export_comment_end = script.source_code.find("\n", export_comment_begin) 
		
		if export_comment_end == -1:
			push_error(
					"ABORTING | Couldn't find a new line after export comment."
					+ "%s must be placed directly above a variable definition"%[EXPORT_TOKEN]
			)
			break
		else:
			var next_line_break = script.source_code.find("\n", export_comment_end + "\n".length())
			var property_line: = script.source_code.substr(
					export_comment_end, next_line_break - export_comment_end
			)
			property_line = property_line.strip_edges()
			
			var property_name: = _get_property_name(property_line)
			if property_name == "":
				push_error("ABORTING | Unable to get a property name from %s"%[property_line])
				break
			
			_properties_to_expose.append(property_name)
		
		export_comment_begin = script.source_code.find(EXPORT_TOKEN, export_comment_end)
	
	_inspector_helper = SharedInspector.new(self, get_parent(), _properties_to_expose)
	property_list_changed_notify()

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _get_property_name(property_line: String) -> String:
	var property_name: = ""
	
	var property_name_begin: = property_line.find("var")
	if property_name_begin == -1:
		push_error("Invalid line, %s must be placed directly above a variable definition"
				%[EXPORT_TOKEN]
		)
		return property_name
	
	property_name_begin += "var".length()
	
	var property_name_end: = property_line.find(":", property_name_begin) 
	if property_name_end == -1:
		property_name_end = property_line.find("=", property_name_begin)
	if property_name_end == -1:
		property_name_end = property_line.length()
	
	property_name = property_line.substr(
			property_name_begin, property_name_end - property_name_begin
	).strip_edges()
	
	return property_name

### -----------------------------------------------------------------------------------------------
