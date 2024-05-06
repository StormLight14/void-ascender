extends Area2D

@export var trigger_limit = 1
@export var event = ""
@export var str_args: Array[String]
@export var num_args: Array[float]
@export var vec2_args: Array[Vector2]

func _on_body_entered(body):
	match event:
		"broadcast":
			Global.broadcast(str_args) # messages, font size, seconds, offset
		"dialog":
			Dialogic.start(str_args[0])
		"hint":
			Global.show_hint()
	trigger_limit -= 1
	if trigger_limit <= 0:
		queue_free()

func _on_area_entered(area):
	match event:
		"kill_area":
			area.queue_free()
