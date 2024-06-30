extends Control

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel") and Global.in_game:
		toggle_pause_menu()

func toggle_pause_menu():
	if Global.ui_open == false:
		Global.ui_open = true
		%PauseUI.visible = true
		get_tree().paused = true
	elif %PauseUI.visible == true:
		%PauseUI.visible = false
		Global.ui_open = false
		get_tree().paused = false

func _on_resume_pressed():
	toggle_pause_menu()

func _on_save_pressed():
	Global.save_game()

func _on_quit_pressed():
	Global.save_game()
	Global.in_game = false
	toggle_pause_menu()
	get_tree().change_scene_to_file("res://ui/menu/menu_ui.tscn")
