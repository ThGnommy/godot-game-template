@tool
extends EditorPlugin

func _enable_plugin():
	add_autoload_singleton("AudioManager", "res://addons/ggt-audio/autoloads/audio_manager.tscn")

func _disable_plugin():
	remove_autoload_singleton("AudioManager")
