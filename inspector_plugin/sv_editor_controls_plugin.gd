# Write your doc string for this file here
extends EditorInspectorPlugin

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------

var sv_update_button: PackedScene = \
		preload("res://addons/eh_jogos.shared_variables/inspector_plugin/UpdateButton.tscn")

#--- private variables - order: export > normal var > onready -------------------------------------

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _init() -> void:
	pass


func can_handle(object: Object) -> bool:
	var is_sv_editor_controls = object is SVEditorControls
	return is_sv_editor_controls


func parse_begin(object: Object) -> void:
	var update_button = sv_update_button.instance()
	add_custom_control(update_button)
	update_button.sv_controls = object

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

### -----------------------------------------------------------------------------------------------
