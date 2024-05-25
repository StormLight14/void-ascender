extends Path2D

# alt + click to move platform in editor

@onready var animated_sprite_2d = %AnimatedSprite2D
@onready var animation_player = $AnimationPlayer

@export var platform_type = "automatic" # possible choices: automatic, triggered
@export var move_speed = 300.0
@export var reverses = true # platform reverses when it reaches end of path
@export var backwards_speed_scale = 0.7

enum { Stopped, Forward, Backward }

var movement = Stopped

func _ready():
	if platform_type == "automatic":
		movement = Forward
		
func _physics_process(delta):
	if movement == Forward:
		if %PathFollow2D.progress < curve.get_baked_length() - move_speed * delta:
			%PathFollow2D.progress += move_speed * delta
		else:
			%PathFollow2D.progress_ratio = curve.get_baked_length()
			if reverses:
				movement = Backward
	elif movement == Backward:
		if %PathFollow2D.progress > 0 + move_speed * delta:
			%PathFollow2D.progress -= move_speed * delta
		else:
			%PathFollow2D.progress_ratio = 0.0
			movement = Forward
