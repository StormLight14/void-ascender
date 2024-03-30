extends Node2D

@onready var spawn_timer = $SpawnTimer

@export var direction = Vector2(0, 0)
@export var spawn_delay = 3
@export var fireball_speed = 100
@export var active = false

signal spawn_fireball(fireball_direction, fireball_speed, spawn_position)

func _ready():
	if active:
		spawn_timer.wait_time = spawn_delay
		spawn_timer.start()
	else:
		visible = false

func _on_spawn_timer_timeout():
	spawn_fireball.emit(direction, fireball_speed, global_position)
