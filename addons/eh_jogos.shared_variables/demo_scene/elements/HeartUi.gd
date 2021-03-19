# Write your doc string for this file here
tool
extends Control

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

const HEART_FULL = 522
const HEART_HALF = 521
const HEART_EMPTY = 520

const HEART_VALUES = {
	0: HEART_EMPTY,
	1: HEART_HALF,
	2: HEART_FULL
}

#--- public variables - order: export > normal var > onready --------------------------------------

var value: int = 2 setget _set_value

#--- private variables - order: export > normal var > onready -------------------------------------

onready var _sprite: Sprite = $HeartSprite

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _ready() -> void:
	pass

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _set_value(p_value: int) -> void:
	value = min(p_value, 2)
	
	if not is_inside_tree():
		yield(self, "ready")
	
	_sprite.frame = HEART_VALUES[value]

### -----------------------------------------------------------------------------------------------
