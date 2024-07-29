extends Node2D

@export var direction = "up"
@export var width = 1000
@export var height = 600
@export var spawn_distance_from_player = 300
@export var h_effect_distance = 40
@export var v_effect_distance = 40
@export var speed = 25

var ROW_OFFSET = -width / 2

var rng = RandomNumberGenerator.new()
var effect_velocities = [-1, 1]

var player_start_pos = Vector2.ZERO
var reset_position = Vector2.ZERO
var count = 0

func _ready():
	if direction == "left" or direction == "right":
		rotation_degrees = 90
		var temp_height = height
		height = width
		width = temp_height
	
	set_reset_position(player_start_pos)
	global_position = reset_position
	
	for row in range(width / h_effect_distance):
		for col in range(height / v_effect_distance):
			var void_effect = preload("res://hazards/void/void_effect.tscn").instantiate()
			void_effect.global_position.x = row * h_effect_distance + rng.randf_range(-15, 15) + ROW_OFFSET
			void_effect.global_position.y = col * v_effect_distance + rng.randf_range(-15, 15)
			void_effect.velocity = Vector2(effect_velocities[rng.randi_range(0, 1)], effect_velocities[rng.randi_range(0, 1)])
			add_child(void_effect)
			
func _physics_process(delta):
	if Global.ui_open == false:
		match direction:
			"up":
				global_position.x = %Player.camera_2d.get_screen_center_position().x
				global_position.y -= speed * delta
			"down":
				global_position.x = %Player.camera_2d.get_screen_center_position().x
				global_position.y += speed * delta
			"left":
				global_position.y = %Player.camera_2d.get_screen_center_position().y
				global_position.x -= speed * delta
			"right":
				global_position.y = %Player.camera_2d.get_screen_center_position().y
				global_position.x += speed * delta
	
	for effect in get_tree().get_nodes_in_group("VoidEffect"):
		if effect.global_position.y < global_position.y:
			effect.velocity.y *= -1
			effect.global_position.y = global_position.y + 1
		elif effect.global_position.y > global_position.y + height:
			effect.velocity.y *= -1
			effect.global_position.y = global_position.y + height
		if effect.global_position.x < global_position.x + ROW_OFFSET:
			effect.velocity.x *= -1
			effect.global_position.x = global_position.x + 1
		elif effect.global_position.x > global_position.x + width:
			effect.velocity.x *= -1
			effect.global_position.x = global_position.x + width
			
func set_reset_position(checkpoint_pos):
	reset_position = checkpoint_pos
	match direction:
		"up":
			reset_position.y += spawn_distance_from_player
		"down":
			reset_position.y -= (spawn_distance_from_player + height)
		"left":
			reset_position.x += spawn_distance_from_player + width / 2
		"right":
			reset_position.x -= spawn_distance_from_player + width / 2
	

func on_player_killed():
	global_position = reset_position
