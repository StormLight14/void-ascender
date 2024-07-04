extends Node2D

@export var width = 10000
@export var height = 600
@export var spawn_distance_from_player = 300
@export var h_effect_distance = 40
@export var v_effect_distance = 40
@export var speed = 25

var ROW_OFFSET = -width / 2

var rng = RandomNumberGenerator.new()
var effect_velocities = [-1, 1]

var reset_position = Vector2.ZERO
var count = 0

func _ready():
	for row in range(width / h_effect_distance):
		for col in range(height / v_effect_distance):
			var void_effect = preload("res://hazards/void/void_effect.tscn").instantiate()
			void_effect.global_position.x = row * h_effect_distance + rng.randf_range(-15, 15) + ROW_OFFSET
			void_effect.global_position.y = col * v_effect_distance + rng.randf_range(-15, 15)
			void_effect.velocity = Vector2(effect_velocities[rng.randi_range(0, 1)], effect_velocities[rng.randi_range(0, 1)])
			add_child(void_effect)
			
func _process(delta):
	global_position.x = %Player.camera_2d.get_screen_center_position().x
	if Global.ui_open == false:
		global_position.y -= speed * delta
	
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
	reset_position.y = checkpoint_pos.y
	reset_position.y += spawn_distance_from_player

func on_player_killed():
	global_position = reset_position
