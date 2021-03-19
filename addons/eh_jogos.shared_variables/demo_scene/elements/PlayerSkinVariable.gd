# Write your doc string for this file here
tool
class_name PlayerSkinVariable
extends IntVariable

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

enum PlayerSkin {
	Blue,
	Yellow,
	Green
}

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------

#--- private variables - order: export > normal var > onready -------------------------------------

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _get_value_property_dict(property_name: String) -> Dictionary:
	var enum_hint_string = str(PlayerSkin.keys()).lstrip("[").rstrip("]").replace(" ", "")
	var dict = {
		name = "%s"%[property_name],
		type = TYPE_INT, 
		usage = PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE,
		hint = PROPERTY_HINT_ENUM,
		hint_string = enum_hint_string
	}
	return dict

### -----------------------------------------------------------------------------------------------
