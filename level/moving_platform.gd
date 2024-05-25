extends Path2D

# alt + click to move platform in editor

@onready var animated_sprite_2d = %AnimatedSprite2D
@onready var animation_player = $AnimationPlayer

@export var platform_type = "automatic" # possible choices: automatic, triggered
@export var move_speed = 300.0
@export var stop_mode = "never" # possible choices: never, reverse (reverse once, then stop), instant
@export var backwards_speed_scale = 0.7

enum { Stopped, Forward, Backward }

var movement = Stopped

func _ready():
	if platform_type == "automatic":
		set_movement(Forward)
	else:
		set_movement(Stopped)
		
func _physics_process(delta):
	if movement == Forward:
		if %PathFollow2D.progress < curve.get_baked_length() - move_speed * delta:
			%PathFollow2D.progress += move_speed * delta
		else:
			%PathFollow2D.progress_ratio = curve.get_baked_length()
			if stop_mode != "instant":
				set_movement(Backward)
			else:
				set_movement(Stopped)
	elif movement == Backward:
		if %PathFollow2D.progress > 0 + move_speed * delta * backwards_speed_scale:
			%PathFollow2D.progress -= move_speed * delta * backwards_speed_scale
		else:
			%PathFollow2D.progress_ratio = 0.0
			if stop_mode == "never":
				set_movement(Forward)
			else:
				set_movement(Stopped)
			
func set_movement(movement_type):
	if movement_type != Stopped:
		animated_sprite_2d.frame = 0
	else:
		animated_sprite_2d.frame = 1
		
	movement = movement_type

func _on_trigger_area_body_entered(_body):
	if platform_type == "triggered" and movement == Stopped:
		set_movement(Forward)
