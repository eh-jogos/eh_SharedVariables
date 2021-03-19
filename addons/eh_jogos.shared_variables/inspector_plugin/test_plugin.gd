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

### -----------------------------------------------------------------------------------------------


### Built in Engine Methods -----------------------------------------------------------------------

func can_handle(object: Object) -> bool:
	var found_shared_variable: = false
	var script: Script = object.get_script()
	if script != null:
		var property_list = script.get_script_property_list()
		var test_object = script.new()
		for dict in property_list:
			if test_object.get(dict.name) is SharedVariable:
				print(test_object.get(dict.name).get_class())
				found_shared_variable = true
				break
	
	return found_shared_variable


func parse_begin(object: Object) -> void:
	var button = shared_variable_category.instance()
	button.connect("pressed", self, "_on_button_pressed", [object])
	add_custom_control(button)


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

### -----------------------------------------------------------------------------------------------
