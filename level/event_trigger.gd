extends Area2D

@export var trigger_limit = 1
@export var event = ""
@export var str_args: Array[String]
@export var num_args: Array[float]
@export var vec2_args: Array[Vector2] = [Vector2(0, -15)]

func _on_body_entered(body):
	if trigger_limit > 0:
		match event:
			"broadcast":
				Global.broadcast(str_args, num_args[0], num_args[1], vec2_args[0]) # messages, font size, seconds, offset
	trigger_limit -= 1
