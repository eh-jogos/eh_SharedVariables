# Write your doc string for this file here
tool
extends Label

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------

#--- private variables - order: export > normal var > onready -------------------------------------

export var shared_variable: Resource = null setget _set_shared_variable

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _ready() -> void:
	pass


func _get_configuration_warning() -> String:
	var msg: = ""
	
	if shared_variable == null:
		msg = "You must set a resource that inherits shared variable" \
				+ "to the expored variable in the inspector for it to work."
	
	return msg

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

func update_text() -> void:
	var variable_name: String = shared_variable.resource_path
	variable_name = variable_name.get_file().replace(".%s"%[variable_name.get_extension()], "")
	text = "%s: %s"%[variable_name, shared_variable.value]

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _set_shared_variable(value: Resource) -> void:
	if value is SharedVariable:
		shared_variable = value
		shared_variable.connect_to(self, "_on_shared_variable_value_updated")
		update_configuration_warning()
		
		if not is_inside_tree():
			yield(self, "ready")
		
		update_text()


func _on_shared_variable_value_updated() -> void:
	update_text()

### -----------------------------------------------------------------------------------------------
