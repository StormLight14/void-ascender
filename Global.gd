extends Node2D

var ui_open = false
var sign_char_index = 0
var sign_text = "placeholder"
var sign_finished = false

func _process(_delta):
	if Input.is_action_just_pressed("ui_accept") and sign_finished:
		get_tree().paused = false
		%Sign.visible = false


func broadcast(messages, seconds = 5, font_size = 8, offset = Vector2(0, -30)):
	%BroadcastLabel.text = messages[0]
	%BroadcastLabel.set("theme_override_font_sizes/font_size", font_size)
	%BroadcastLabel.set("position", Vector2(0 + offset.x, 121 + offset.y))
	%BroadcastTimer.wait_time = seconds
	%BroadcastTimer.start()
	%AnimationPlayer.play("broadcast_fade_in")
	
func show_sign_text(text):
	%Sign.visible = true
	%SignLabel.text = ""
	sign_finished = false
	get_tree().paused = true
	sign_char_index = 0
	
	if text:
		sign_text = text

	%CharDisplayTimer.start()
	
func _on_char_display_timer_timeout():
	if sign_char_index < len(sign_text):
		%SignLabel.text += sign_text[sign_char_index]
		sign_char_index += 1
	else:
		sign_finished = true
	
func _on_broadcast_timer_timeout():
	%AnimationPlayer.play("broadcast_fade_out")

func save_game():
	pass

