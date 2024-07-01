extends Area2D

signal captured

func _on_body_entered(body):
	Global.level_data[Global.current_level].completed = true
	Global.save_game()
	Global.in_game = false
	captured.emit()
