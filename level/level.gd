extends Node2D

@onready var player = %Player
@onready var the_void = %Void
@onready var game_ui = %GameUI

var player_spawn = Vector2(0, 0)

func _ready():
	modulate = Color(1, 1, 1, 1)
	player_spawn = player.global_position
	player.killed.connect(player_killed)
	the_void.set_reset_position(player.global_position)
	
	for fireball_spawner in get_tree().get_nodes_in_group("FireballSpawner"):
		fireball_spawner.spawn_fireball.connect(spawn_fireball)
		
	for checkpoint in get_tree().get_nodes_in_group("Checkpoint"):
		checkpoint.captured.connect(checkpoint_captured)
	
func _process(_delta):
	check_void_killed_player()
	game_ui.get_node("VoidDistance").text = str(round(get_void_distance())) + "m..."

func get_void_distance():
	# 1 pixel = 0.025 meters
	return ceil(abs(player.global_position.y - the_void.global_position.y) / 40)
	
func player_killed():
	the_void.on_player_killed()
	player.global_position = player_spawn

func spawn_fireball(direction, speed, lifetime, spawn_position):
	var fireball = preload("res://hazards/fireball/fireball.tscn").instantiate()
	fireball.direction = direction
	fireball.speed = speed
	fireball.lifetime = lifetime
	fireball.global_position = spawn_position
	add_child(fireball)
	
func check_void_killed_player():
	if player.global_position.y > the_void.global_position.y - 12:
		player_killed()

func checkpoint_captured(checkpoint):
	for checkpoint_node in get_tree().get_nodes_in_group("Checkpoint"):
		checkpoint_node.reset()
	checkpoint.capture()
	player_spawn = checkpoint.global_position
	the_void.set_reset_position(checkpoint.global_position)
