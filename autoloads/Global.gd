extends Node2D

var ui_open = false
var in_game = false
var continue_from_checkpoint = false
var current_level = "0"

var level_data = {
	"0": { # tutorial
		"completed": false,
		"last_checkpoint": null
	},
	"1": {
		"completed": false,
		"last_checkpoint": null
	},
	"2": {
		"completed": false,
		"last_checkpoint": null
	},
}
var deaths = 0

func broadcast(messages, seconds = 5, font_size = 8, offset = Vector2(0, -30)):
	%BroadcastLabel.text = messages[0]
	%BroadcastLabel.set("theme_override_font_sizes/font_size", font_size)
	%BroadcastLabel.set("position", Vector2(0 + offset.x, 121 + offset.y))
	%BroadcastTimer.wait_time = seconds
	%BroadcastTimer.start()
	%BroadcastAnimationPlayer.play("broadcast_fade_in")
	
func _on_broadcast_timer_timeout():
	%BroadcastAnimationPlayer.play("broadcast_fade_out")
	
func show_hint(_hint_message):
	pass

func save_game():
	var save_file = FileAccess.open("user://game_save.json", FileAccess.WRITE)
	var save_dict = {
		"level_data": level_data,
		"deaths": deaths
	}

	save_file.store_line(JSON.stringify(save_dict))

func load_game():
	if not FileAccess.file_exists("user://game_save.json"):
		return
	var json = JSON.new()
	
	var save_file = FileAccess.open("user://game_save.json", FileAccess.READ)
	if json.parse(save_file.get_as_text()) != OK:
		print("JSON Parse Error: ", json.get_error_message(), " in ", save_file.get_as_text(), " at line ", json.get_error_line())
		return
	
	var save_data = json.get_data()
	level_data = save_data["level_data"]
	for level in level_data:
		if level_data[level].last_checkpoint:
			level_data[level].last_checkpoint = str_to_var("Vector2" + level_data[level].last_checkpoint)
	deaths = int(save_data["deaths"])

func fade_in():
	%FadeAnimationPlayer.play("fade_in")
	
func fade_out():
	%FadeAnimationPlayer.play("fade_out")
