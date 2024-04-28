extends Control

var level_scene: PackedScene = null

# Called when the node enters the scene tree for the first time.
func _ready():
	for button in get_tree().get_nodes_in_group("LevelButton"):
		button.level_pressed.connect(level_pressed)

func level_pressed(level):
	level_scene = level
	%Start.disabled = false
	%Continue.disabled = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_start_pressed():
	get_tree().change_scene_to_packed(level_scene)

func _on_continue_pressed():
	pass # Replace with function body.
