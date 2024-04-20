extends Control

func _on_new_game_pressed():
	get_tree().change_scene_to_file("res://level/level.tscn")

func _on_continue_pressed():
	get_tree().change_scene_to_file("res://ui/level_select.tscn")

func _on_settings_pressed():
	get_tree().change_scene_to_file("res://ui/settings.tscn")

func _on_quit_pressed():
	get_tree().quit()
