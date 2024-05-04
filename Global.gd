extends Node

#func _process(_delta):
#	if Dialogic.current_timeline != null:
#		get_tree().paused = true

func broadcast(message, font_size = 10, seconds = 5):
	for player in get_tree().get_nodes_in_group("Player"):
		player.start_broadcast(message, font_size, seconds)

func save_game():
	pass

