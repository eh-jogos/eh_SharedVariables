# Write your doc string for this file here
tool
extends OptionButton

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------

#--- private variables - order: export > normal var > onready -------------------------------------

var _player_skin: PlayerSkinVariable = PlayerSkinVariable.new()

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _ready() -> void:
	clear()
	for key in PlayerSkinVariable.PlayerSkin.keys():
		add_item(key)
	
	connect("item_selected", self, "_on_item_selected")
	selected = _player_skin.value
	_player_skin.connect_to(self, "_on_player_skin_value_updated")

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _on_item_selected(index: int) -> void:
	_player_skin.value = PlayerSkinVariable.PlayerSkin[get_item_text(index)]


func _on_player_skin_value_updated() -> void:
	selected = _player_skin.value

### -----------------------------------------------------------------------------------------------


###################################################################################################
### Shared Variables Editor Methods ###############################################################
###################################################################################################

var inspector_helper = SharedInspector.new(
	self, 
	[
		"_player_skin",
	]
)

func _set(property: String, value) -> bool:
	var has_handled: = false
	has_handled = inspector_helper._set(property, value)
	return has_handled


func _get(property: String):
	var to_return = null
	to_return = inspector_helper._get(property)
	return to_return


func _get_property_list() -> Array:
	var properties: Array = inspector_helper._get_property_list()
	return properties
