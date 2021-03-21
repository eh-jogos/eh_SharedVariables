# This script doesn't actually do anything, it just serves to turn on or off the ability to
# Create resources of the "-Variable" types from the editor, otherwise the class_names inside
# "addons" folder get ignored by the "Create New ..." dialog in the Editor.
# For more info see Github issue - https://github.com/godotengine/godot/issues/30048
tool
extends EditorPlugin

#const TEST_PLUGIN = preload("res://addons/eh_jogos.shared_variables/test_plugin.gd")

#var plugin

func _enter_tree():
#	plugin = TEST_PLUGIN.new()
#	plugin.editor_interface = get_editor_interface()
#	plugin.script_editor = get_editor_interface().get_script_editor()
#	add_inspector_plugin(plugin)
	pass


func _exit_tree():
#	remove_inspector_plugin(plugin)
	pass
