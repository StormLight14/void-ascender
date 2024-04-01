extends Node2D

@onready var player = %Player
@onready var the_void = %Void
@onready var game_ui = %GameUI

var player_spawn = Vector2(0, 0)

func _ready():
	player_spawn = player.global_position
	player.killed.connect(player_killed)
	the_void.set_reset_position(player.global_position)
	
	for fireball_spawner in get_tree().get_nodes_in_group("FireballSpawner"):
		fireball_spawner.spawn_fireball.connect(spawn_fireball)
		
	for checkpoint in get_tree().get_nodes_in_group("Checkpoint"):
		checkpoint.captured.connect(checkpoint_captured)
	
func _process(_delta):
	game_ui.get_node("VoidDistance").text = str(round(get_void_distance())) + "m..."

func get_void_distance():
	# 1 pixel = 0.025 meters
	return ceil(abs(player.global_position.y - the_void.global_position.y) / 40)
	
func player_killed():
	the_void.on_player_killed()
	void_follow_player()
	player.global_position = player_spawn
	
func void_follow_player():
	the_void.global_position.x = player.global_position.x - the_void.width / 2.0

func spawn_fireball(direction, speed, spawn_position):
	var fireball = preload("res://hazards/fireball/fireball.tscn").instantiate()
	fireball.direction = direction
	fireball.speed = speed
	fireball.global_position = spawn_position
	add_child(fireball)

func checkpoint_captured(checkpoint):
	for checkpoint_node in get_tree().get_nodes_in_group("Checkpoint"):
		checkpoint_node.reset()
	checkpoint.capture()
	player_spawn = checkpoint.global_position
	the_void.set_reset_position(checkpoint.global_position)
	print("captured")
