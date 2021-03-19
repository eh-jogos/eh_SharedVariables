# Write your doc string for this file here
tool
extends VBoxContainer

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------

var health_max: IntVariable = IntVariable.new()
var health_current: IntVariable = IntVariable.new()
var player_name: StringVariable = StringVariable.new()
var player_skin: PlayerSkinVariable = PlayerSkinVariable.new()

#--- private variables - order: export > normal var > onready -------------------------------------

var _player_state: StringVariable = \
		load("res://addons/eh_jogos.shared_variables/demo_scene/shared_variables/player_state.tres")

onready var _name: Label = $HeroName
onready var _hero_container: Control = $HeroContainer

onready var _possible_skins: = {
	PlayerSkinVariable.PlayerSkin.Blue: $HeroContainer/BlueHero,
	PlayerSkinVariable.PlayerSkin.Yellow: $HeroContainer/YellowHero,
	PlayerSkinVariable.PlayerSkin.Green: $HeroContainer/GreenHero
}

onready var _current_animated_sprite: AnimatedSprite = _possible_skins[player_skin.value]

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _ready() -> void:
	player_name.connect_to(self, "_on_player_name_value_updated")
	player_skin.connect_to(self, "_on_player_skin_value_updated")
	health_current.connect_to(self, "_on_health_current_value_updated")
	
	update_player_name()
	change_skin()

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

func update_player_name() -> void:
	_name.text = player_name.value


func change_skin() -> void:
	_current_animated_sprite = _possible_skins[player_skin.value]
	for child in _hero_container.get_children():
		child.visible = child == _current_animated_sprite
	
	update_sprite_animation()


func update_sprite_animation() -> void:
	if health_current.value > 0:
		_current_animated_sprite.animation = "run"
		_player_state.value = "alive"
	else:
		_current_animated_sprite.animation = "dead"
		_player_state.value = "dead"

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _on_player_name_value_updated() -> void:
	update_player_name()


func _on_player_skin_value_updated() -> void:
	change_skin()


func _on_health_current_value_updated() -> void:
	update_sprite_animation()

### -----------------------------------------------------------------------------------------------


###################################################################################################
### Shared Variables Editor Methods ###############################################################
###################################################################################################

var inspector_helper = SharedInspector.new(
	self, 
	[
		"health_max", 
		"health_current",
		"player_name",
		"player_skin",
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
