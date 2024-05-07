extends Node2D

@onready var spawn_timer = $SpawnTimer
@onready var sprite_2d = $Sprite2D

@export var spawn_delay = 3.0
@export var fireball_speed = 150
@export var fireball_lifetime = 3
@export var active = true

signal spawn_fireball(fireball_direction, fireball_speed, spawn_position)

var direction = Vector2.ZERO

func _ready():
	direction = Vector2.RIGHT.rotated(rotation)
	print(direction)
	if active:
		spawn_timer.wait_time = spawn_delay
		spawn_timer.start()
	else:
		visible = false
		

func _on_spawn_timer_timeout():
	spawn_fireball.emit(direction, fireball_speed, fireball_lifetime, global_position)
