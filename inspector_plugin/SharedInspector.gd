# Write your doc string for this file here
class_name SharedInspector
extends Reference

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------

var shared_properties: = {}
var parent_node: Node

#--- private variables - order: export > normal var > onready -------------------------------------

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _init(node: Node, properties: Array) -> void:
	parent_node = node
	for property in properties:
		var key: String = "_%s"%[property]
		shared_properties[key] = property


func _set(property: String, value) -> bool:
	var has_handled: = false
	if shared_properties.has(property):
		parent_node.set(shared_properties[property], value)
		parent_node.set_meta(
				shared_properties[property], 
				parent_node.get(shared_properties[property])
		)
		has_handled = true
	
	return has_handled


func _get(property: String):
	var to_return = null
	if shared_properties.has(property):
		if parent_node.has_meta(shared_properties[property]):
			to_return = parent_node.get_meta(shared_properties[property])
		else:
			to_return = parent_node.get(shared_properties[property])
	
	return to_return


func _get_property_list() -> Array:
	var properties: = SharedVariable.get_properties_for(shared_properties.keys())
	return properties

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

### -----------------------------------------------------------------------------------------------
