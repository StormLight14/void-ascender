extends Area2D

@export var dialog_name: String = "placeholder"

var can_interact = false

func _process(_delta):
	if Input.is_action_just_pressed("interact") and can_interact and Dialogic.current_timeline == null and dialog_name:
		Dialogic.start(dialog_name)

func _on_body_entered(body):
	can_interact = true
	%Arrow.visible = true

func _on_body_exited(body):
	can_interact = false
	%Arrow.visible = false
