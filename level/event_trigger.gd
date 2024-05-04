extends Area2D

@export var trigger_limit = 1
@export var event = ""
@export var str_args: Array[String]
@export var int_args: Array[int]
@export var vec2_args: Array[Vector2]

func _on_body_entered(body):
	if trigger_limit > 0:
		match event:
			"broadcast":
				Global.broadcast(str_args[0], int_args[0], int_args[1]) # message, font size, seconds
	trigger_limit -= 1
