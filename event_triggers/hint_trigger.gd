extends Area2D

@export var trigger_limit = 1
@export var message = ""

func _on_body_entered(body):
	Global.show_hint(message)

	trigger_limit -= 1
	if trigger_limit <= 0:
		queue_free()

func _on_area_entered(area):
	pass # Replace with function body.
