# Write your doc string for this file here
extends EditorInspectorPlugin

### Member Variables and Dependencies -------------------------------------------------------------
#--- signals --------------------------------------------------------------------------------------

#--- enums ----------------------------------------------------------------------------------------

#--- constants ------------------------------------------------------------------------------------

#--- public variables - order: export > normal var > onready --------------------------------------

var shared_variable_category = \
		preload("res://addons/eh_jogos.shared_variables/inspector_plugin/TestLabel.tscn")
var editor_interface: EditorInterface
var script_editor: ScriptEditor


#--- private variables - order: export > normal var > onready -------------------------------------

var _workspace = Engine.get_singleton("GDScriptLanguageProtocol").get_workspace()
var _inheritance_table: Dictionary = {}

# An array of dictionaries. The dictionary format for each member is:
#{
#	"name": "player_name_load",
#	"data_type": "StringVariable",
#	"default_value": null,
#	"setter": "",
#	"getter": "",
#	"export": false,
#	"signature": "var player_name_load: StringVariable",
#	"description": ""
#}
var _current_members: Array = []

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func _init() -> void:
	for dict in ProjectSettings._global_script_classes:
		if not _inheritance_table.has(dict["class"]):
			_inheritance_table[dict["class"]] = []
		_inheritance_table[dict["class"]].append(dict["base"])
	
	for type in _inheritance_table.keys():
		var inheritance: Array = _inheritance_table[type]
		var last_ineritance = inheritance.back()
		for value in _inheritance_table.values():
			if type == value.back():
				value.append(last_ineritance)


func can_handle(object: Object) -> bool:
	var found_shared_variable: = false
	_current_members.clear()
	
	var script: Script = object.get_script()
	if script != null:
		var file_path: = script.resource_path
		if file_path.ends_with(".gd"):
#			_workspace.parse_local_script(file_path)
			var symbols: Dictionary = _workspace.generate_script_api(file_path)
			for member in symbols.members:
				var data_type: String = member.data_type
				found_shared_variable = _does_inherit_from_shared_variable(data_type)
				if found_shared_variable:
					_current_members = symbols.members.duplicate(true)
					break
	
	return found_shared_variable


func parse_begin(object: Object) -> void:
	print(object.get_property_list())
	for member in _current_members:
		if _does_inherit_from_shared_variable(member.data_type):
			var editor_property: = EditorProperty.new()
			editor_property.label = member.name.capitalize()
			editor_property.hint_tooltip = member.name
			editor_property.add_child(LineEdit.new())
			add_property_editor(member.name, editor_property)


func _on_button_pressed(object: Object) -> void:
	var script: Script = object.get_script()
	var open_scripts = script_editor.get_open_scripts()
	var script_index = open_scripts.find(script)
	if script_index != -1:
		print("FOUND OPEN SCRIPT")
		# open Popup to ask the user to save and close the script
	else:
		print("Didn't find %s in %s"%[script, open_scripts])
		script.source_code += "\n# %s"%[object.name]
		ResourceSaver.save(script.resource_path, script)
		script.take_over_path(script.resource_path)


### -----------------------------------------------------------------------------------------------


### Public Methods --------------------------------------------------------------------------------

### -----------------------------------------------------------------------------------------------


### Private Methods -------------------------------------------------------------------------------

func _does_inherit_from_shared_variable(data_type: String) -> bool:
	var does_inherit: = false
	if _inheritance_table.has(data_type):
		does_inherit = _inheritance_table[data_type].has("SharedVariable")
	return does_inherit

### -----------------------------------------------------------------------------------------------
