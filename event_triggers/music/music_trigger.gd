extends Area2D

@export var trigger_limit = 1
@export var music = AudioStream

func _on_body_entered(body):
	Music.music_player.steam = music;

	trigger_limit -= 1
	if trigger_limit <= 0:
		queue_free()

func _on_area_entered(area):
	pass # Replace with function body.
