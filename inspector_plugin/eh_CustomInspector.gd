# Write your doc string for this file here
class_name eh_CustomInspector
extends Reference

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------

var shared_properties: = {}
var node_origin: Node
var node_inspector_control: Node

#--- private variables - order: export > normal var > onready -------------------------------------

var _category_name: String = ""

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _init(p_inspector: Node, p_origin: Node, properties: Array, category: String) -> void:
	node_inspector_control = p_inspector
	node_origin = p_origin
	_category_name = category
	for property in properties:
		var key: String = "_%s"%[property]
		shared_properties[key] = property


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
	var properties: = _get_properties_for(shared_properties.keys())
	return properties

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

func has_property(p_property: String) -> bool:
	return shared_properties.has(p_property)

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _get_property_category() -> Dictionary:
	var dict = {
		name = _category_name,
		type = TYPE_NIL,
		usage = PROPERTY_USAGE_CATEGORY,
	}
	return dict


func _get_property_dict(property_name: String) -> Dictionary:
	var dict = {
		name = "%s"%[property_name],
		type = TYPE_OBJECT,
		usage = PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE,
		hint = PROPERTY_HINT_RESOURCE_TYPE,
		hint_string = "Resource"
	}
	return dict


func _get_properties_for(names: PoolStringArray) ->  Array:
	var properties: = []
	properties.append(_get_property_category())
	for name in names:
		properties.append(_get_property_dict(name))
	return properties


### -----------------------------------------------------------------------------------------------
