extends Node2D

@onready var player = %Player
@onready var the_void = %Void
@onready var fireball_spawner = %FireballSpawner

var player_spawn = Vector2(0, 0)

func _ready():
	player_spawn = player.global_position
	player.killed.connect(player_killed)
	fireball_spawner.spawn_fireball.connect(spawn_fireball)
	
func player_killed():
	the_void.on_player_killed()
	player.global_position = player_spawn

func spawn_fireball(direction, speed, spawn_position):
	var fireball = preload("res://hazards/fireball/fireball.tscn").instantiate()
	fireball.direction = direction
	fireball.speed = speed
	fireball.global_position = spawn_position
	add_child(fireball)