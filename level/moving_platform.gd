extends Node2D

# alt + click to move platform in editor

@onready var animated_sprite_2d = %AnimatedSprite2D
@onready var animation_player = $AnimationPlayer

@export var platform_type = "automatic" # possible choices: automatic, triggered
@export var move_time = 1.0 # in seconds
@export var reverses = true # platform reverses when it reaches end of path
@export var backwards_speed_scale = 0.7

func _ready():
	if platform_type == "automatic":
		move()
	
func move():
	animation_player.speed_scale = 1 / move_time
	animation_player.play("move")
	
func move_backward():
	animation_player.speed_scale = 1 / move_time * backwards_speed_scale
	animation_player.play("move_backward")

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "move" and reverses:
		move_backward()
	elif anim_name == "move_backward" and platform_type == "automatic":
		move()
