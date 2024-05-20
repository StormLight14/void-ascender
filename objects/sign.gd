extends Area2D

@export var text: String = ""

var can_interact = false

func _process(_delta):
	if Input.is_action_just_pressed("interact") and can_interact:
		Global.show_sign_text(text)

func _on_body_entered(body):
	can_interact = true
	%Arrow.visible = true

func _on_body_exited(body):
	can_interact = false
	%Arrow.visible = false
	print("exited")
