# Write your doc string for this file here
tool
class_name eh_TextureSetter
extends Node

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------

#--- private variables - order: export > normal var > onready -------------------------------------

var _texture_variable: TextureVariable = null setget _set_texture_variable
var _viewport: Viewport = null

var _custom_editor: = eh_CustomInspector.new(
		self, 
		["_texture_variable"],
		""
)

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _enter_tree() -> void:
	_custom_editor.set_source_properties()


func _ready() -> void:
	_viewport = get_parent() as Viewport
	update_configuration_warning()
	
	if _texture_variable != null and _viewport != null:
		_texture_variable.value = _viewport.get_texture()
		set_process(true)
	else:
		set_process(false)


func _process(_delta: float) -> void:
	if eh_EditorHelpers.is_editor() and not _texture_variable.show_preview:
		return
	
	var image_texture = ImageTexture.new()
	var image: Image = _viewport.get_texture().get_data()
	image_texture.create_from_image(image, Texture.FLAG_FILTER)
	_texture_variable.value = image_texture


func _exit_tree() -> void:
	if eh_EditorHelpers.is_editor():
		return
	
	if _texture_variable != null:
		_texture_variable.reset()


func _get_property_list() -> Array:
	var properties = _custom_editor._get_property_list()
	return properties


func _set(property: String, value) -> bool:
	var has_handled: bool = _custom_editor._set(property, value)
	
	if has_handled:
		update_configuration_warning()
	
	return has_handled


func _get(property: String):
	return _custom_editor._get(property)


func _get_configuration_warning() -> String:
	var msg: = ""
	
	if _texture_variable == null:
		msg = "You must set a TextureVariable resource in the editor for this node to work"
	elif _viewport == null:
		msg = "This node must be a child of Viewport to work."
	
	return msg

### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _set_texture_variable(value: TextureVariable) -> void:
	_texture_variable = value
	update_configuration_warning()

### -----------------------------------------------------------------------------------------------
