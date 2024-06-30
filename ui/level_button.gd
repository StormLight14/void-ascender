extends Button

@export var level_scene: PackedScene

signal level_pressed(level_scene)

func _on_pressed():
	level_pressed.emit(str(name), level_scene)
