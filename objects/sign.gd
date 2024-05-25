extends Area2D

@export var sign_text: String = "placeholder"

var can_interact = false
var sign_char_index = 0
var sign_finished = false

func _process(_delta):
	if Input.is_action_just_pressed("interact") and can_interact and Global.ui_open == false:
		show_sign_text()
	
	if Input.is_action_just_pressed("ui_continue") and sign_finished:
		Global.ui_open = false
		%SignUI.visible = false
		
func show_sign_text():
	%SignUI.visible = true
	%SignLabel.text = ""
	sign_finished = false
	Global.ui_open = true
	sign_char_index = 0

	%CharDisplayTimer.start()
	
func _on_char_display_timer_timeout():
	if sign_char_index < len(sign_text):
		%SignLabel.text += sign_text[sign_char_index]
		sign_char_index += 1
	else:
		sign_finished = true

func _on_body_entered(_body):
	can_interact = true
	%Arrow.visible = true

func _on_body_exited(_body):
	can_interact = false
	%Arrow.visible = false
	print("exited")
