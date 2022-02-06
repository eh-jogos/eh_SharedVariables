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
var _viewport_path: NodePath

var _custom_editor: = eh_CustomInspector.new(
		self, 
		["_texture_variable"],
		""
)

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _enter_tree() -> void:
	_viewport = get_parent() as Viewport
	update_configuration_warning()
	
	if _viewport:
		_viewport_path = _viewport.get_path()
	else:
		_viewport_path = NodePath("")


func _ready() -> void:
	_update_texture_variable()
	
	if eh_EditorHelpers.is_editor():
		eh_EditorHelpers.connect_between(
				_texture_variable, "preview_requested", 
				self, "_on_texture_variable_preview_requested"
		)


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


func _update_texture_variable() -> void:
	if _texture_variable != null and _viewport != null:
		var viewport_texture: ViewportTexture = _viewport.get_texture()
		
		if is_inside_tree():
			viewport_texture.viewport_path = _viewport.get_path()
			_viewport_path = _viewport.get_path()
		elif _viewport_path != NodePath(""):
			viewport_texture.viewport_path = _viewport_path
		
		_texture_variable.value = viewport_texture


func _on_texture_variable_preview_requested() -> void:
	_update_texture_variable()

### -----------------------------------------------------------------------------------------------
