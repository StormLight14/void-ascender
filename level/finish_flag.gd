extends Area2D

func _on_body_entered(body):
	Global.level_data[Global.current_level].completed = true
	Global.save_game()
	get_tree().change_scene_to_file("res://ui/level_select.tscn")
