# Write your doc string for this file here
class_name eh_Resetable
extends Resource

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------

#--- private variables - order: export > normal var > onready -------------------------------------

var _reset_list: Dictionary = {}

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

func has_object(p_object: Object) -> bool:
	var instance_id: int = p_object.get_instance_id()
	return _reset_list.has(instance_id)


func add_reset_function(p_object: Object, p_method: String, p_arguments: Array = []) -> void:
	var instance_id: int = p_object.get_instance_id()
	if not _reset_list.has(instance_id):
		# print("Adding reset for: %s"%[p_object.resource_name])
		_reset_list[instance_id] = {
			reset_function = funcref(p_object, p_method),
			arguments = p_arguments
		}


func remove_reset_for(p_object: Object) -> void:
	var instance_id: int = p_object.get_instance_id()
	if _reset_list.has(instance_id):
		_reset_list.erase(instance_id)


func reset_all() -> void:
	for dictionary in _reset_list.values():
		var reset_function: FuncRef = dictionary.reset_function
		reset_function.call_funcv(dictionary.arguments)

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

### -----------------------------------------------------------------------------------------------
