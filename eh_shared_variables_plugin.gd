# This script is mostly to turn on or off the ability to create resources of the "-Variable" 
# types from the editor, otherwise the class_names inside "addons" folder get ignored by the 
# "Create New ..." dialog in the Editor.
# For more info see Github issue - https://github.com/godotengine/godot/issues/30048
# But since I'm here I'm also adding some plugins and tools to make using SharedVariables easier.
tool
extends EditorPlugin

const SV_EDITOR_CONTROLS_PLUGIN_CLASS = preload(\
		"res://addons/eh_jogos.shared_variables/inspector_plugin/sv_editor_controls_plugin.gd"\
)

var sv_editor_controls_plugin

func _enter_tree():
	sv_editor_controls_plugin = SV_EDITOR_CONTROLS_PLUGIN_CLASS.new()
	add_inspector_plugin(sv_editor_controls_plugin)


func _exit_tree():
	remove_inspector_plugin(sv_editor_controls_plugin)
