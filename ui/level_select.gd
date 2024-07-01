extends Control

var level_scene: PackedScene = null

# Called when the node enters the scene tree for the first time.
func _ready():
	for button in get_tree().get_nodes_in_group("LevelButton"):
		button.level_pressed.connect(level_pressed)
		var level = str(button.name)
		if int(level) > 0:
			# button disabled if previous level not completed
			button.disabled = not Global.level_data[str(int(level) - 1)].completed

func level_pressed(level, scene):
	Global.current_level = level
	level_scene = scene
	%Start.disabled = false
	if Global.level_data[level].last_checkpoint:
		%Continue.disabled = false
	else:
		%Continue.disabled = true

func _on_start_pressed():
	get_tree().change_scene_to_packed(level_scene)

func _on_continue_pressed():
	if Global.level_data[Global.current_level].last_checkpoint:
		Global.continue_from_checkpoint = true
		get_tree().change_scene_to_packed(level_scene)
