extends Node2D

@onready var spawn_timer = $SpawnTimer
@onready var sprite_2d = $Sprite2D

@export var direction = Vector2(0, 0)
@export var spawn_delay = 3
@export var fireball_speed = 100
@export var active = true

signal spawn_fireball(fireball_direction, fireball_speed, spawn_position)

func _ready():
	if active:
		spawn_timer.wait_time = spawn_delay
		spawn_timer.start()
	else:
		visible = false
		
	if direction != Vector2.ZERO:
		sprite_2d.look_at(direction * 1000)

func _on_spawn_timer_timeout():
	spawn_fireball.emit(direction, fireball_speed, global_position)
