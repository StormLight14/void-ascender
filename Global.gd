extends Node

#func _process(_delta):
#	if Dialogic.current_timeline != null:
#		get_tree().paused = true

func broadcast(messages, font_size = 8, seconds = 5, offset = Vector2(0, -30)):
	for player in get_tree().get_nodes_in_group("Player"):
		player.start_broadcast(messages, font_size, seconds, offset)

func save_game():
	pass

