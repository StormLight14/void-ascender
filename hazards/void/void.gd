extends Area2D

@export var width = 10000
@export var height = 600
@export var h_effect_distance = 35
@export var v_effect_distance = 35

var rng = RandomNumberGenerator.new()
var effect_velocities = [-1, 1]

var speed = 25
var reset_position = Vector2.ZERO
var count = 0

func _ready():
	reset_position = global_position
	for row in range(width / h_effect_distance):
		for col in range(height / v_effect_distance):
			var void_effect = preload("res://hazards/void/void_effect.tscn").instantiate()
			void_effect.global_position.x = row * h_effect_distance + rng.randf_range(-15, 15)
			void_effect.global_position.y = col * v_effect_distance + rng.randf_range(-15, 15)
			void_effect.velocity = Vector2(effect_velocities[rng.randi_range(0, 1)], effect_velocities[rng.randi_range(0, 1)])
			add_child(void_effect)
			
func _process(delta):
	global_position.y -= speed * delta
	
	for effect in get_tree().get_nodes_in_group("VoidEffect"):
		if effect.global_position.y < global_position.y:
			effect.velocity.y *= -1
			effect.global_position.y = global_position.y + 1
		elif effect.global_position.y > global_position.y + height:
			effect.velocity.y *= -1
			effect.global_position.y = global_position.y + height
		if effect.global_position.x < global_position.x:
			effect.velocity.x *= -1
			effect.global_position.x = global_position.x + 1
		elif effect.global_position.x > global_position.x + width:
			effect.velocity.x *= -1
			effect.global_position.x = global_position.x + width

func on_player_killed():
	global_position = reset_position
