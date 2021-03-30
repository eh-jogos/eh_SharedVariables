# Write your doc string for this file here
class_name SharedInspector
extends Reference

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------

var shared_properties: = {}
var shared_hint_strings: = {}
var node_origin: Node
var node_inspector_control: Node

#--- private variables - order: export > normal var > onready -------------------------------------

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _init(p_inspector: Node, p_origin: Node, properties: Array) -> void:
	node_inspector_control = p_inspector
	node_origin = p_origin
	for dict in properties:
		var key: String = "_%s"%[dict.property]
		shared_properties[key] = dict.property
		shared_hint_strings[key] = dict.hint_string


func _set(property: String, value) -> bool:
	var has_handled: = false
	if shared_properties.has(property):
		node_origin.set(shared_properties[property], value)
		node_inspector_control.set_meta(
				shared_properties[property], 
				value
		)
		has_handled = true
	
	return has_handled


func _get(property: String):
	var to_return = null
	if shared_properties.has(property):
		if node_inspector_control.has_meta(shared_properties[property]):
			to_return = node_inspector_control.get_meta(shared_properties[property])
		else:
			to_return = node_origin.get(shared_properties[property])
	
	return to_return


func _get_property_list() -> Array:
	var properties: = SharedVariable.get_properties_for(
			shared_properties.keys(), 
			shared_hint_strings
	)
	return properties

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

### -----------------------------------------------------------------------------------------------
