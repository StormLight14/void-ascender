extends Area2D

@export var trigger_limit = 1
@export var messages: Array[String] = []
@export var broadcast_time = 0.0

func _on_body_entered(_body):
	Global.broadcast(messages, broadcast_time) # messages, seconds, font size, offset

	trigger_limit -= 1
	if trigger_limit <= 0:
		queue_free()

func _on_area_entered(_area):
	pass # Replace with function body.
