extends Node2D

@onready var player = %Player
@onready var the_void = %Void
@onready var game_ui = %GameUI

@export var level_music: AudioStream = null;

var player_spawn = Vector2(0, 0)

func _ready():
	%FadeAnimationPlayer.play("fade_in")
	Music.music_player.stream = level_music;
	Music.music_player.playing = true;
	modulate = Color(1, 1, 1, 1)
	player_spawn = player.global_position
	player.killed.connect(player_killed)
	the_void.player_start_pos = player.global_position
	
	for fireball_spawner in get_tree().get_nodes_in_group("FireballSpawner"):
		fireball_spawner.spawn_fireball.connect(spawn_fireball)
		
	for checkpoint in get_tree().get_nodes_in_group("Checkpoint"):
		checkpoint.captured.connect(checkpoint_captured)
		
	for flag in get_tree().get_nodes_in_group("FinishFlag"):
		flag.captured.connect(finish_flag_captured)
	
func _process(_delta):
	game_ui.get_node("VoidDistance").text = str(round(get_void_distance())) + "m..."

func get_void_distance():
	# 1 pixel = 0.025 meters
	match the_void.direction:
		"up":
			return ceil(abs(player.global_position.y - the_void.global_position.y) / 40)
		"down":
			return ceil(abs(player.global_position.y + the_void.global_position.y + the_void.height) / 40)
		"left":
			return ceil(abs(player.global_position.x - the_void.global_position.y + (the_void.width / 2)) / 40)
		"right":
			return ceil(abs(player.global_position.x + the_void.global_position.y + (the_void.width / 2)) / 40)
	
func player_killed():
	the_void.on_player_killed()
	player.global_position = player_spawn
	Global.level_data[Global.current_level].deaths += 1
	Global.total_deaths += 1
	player.velocity.y = 0

func spawn_fireball(direction, speed, lifetime, spawn_position):
	var fireball = preload("res://hazards/fireball/fireball.tscn").instantiate()
	fireball.direction = direction
	fireball.speed = speed
	fireball.lifetime = lifetime
	fireball.global_position = spawn_position
	add_child(fireball)

func checkpoint_captured(checkpoint):
	for checkpoint_node in get_tree().get_nodes_in_group("Checkpoint"):
		checkpoint_node.reset()
	checkpoint.capture()
	player_spawn = checkpoint.global_position
	the_void.set_reset_position(checkpoint.global_position)
	Global.level_data[Global.current_level].last_checkpoint = checkpoint.global_position
	Global.save_game()

func finish_flag_captured():
	%FadeAnimationPlayer.play("fade_out")

func _on_fade_animation_player_animation_finished(anim_name):
	if anim_name == "fade_out":
		get_tree().change_scene_to_file("res://ui/menu/level_select.tscn")
