extends Node

#func _process(_delta):
#	if Dialogic.current_timeline != null:
#		get_tree().paused = true

func broadcast(messages, seconds = 5, font_size = 8, offset = Vector2(0, -30)):
	for player in get_tree().get_nodes_in_group("Player"):
		player.start_broadcast(messages, seconds, font_size, offset)

func save_game():
	pass

