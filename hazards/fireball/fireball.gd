extends Area2D

@onready var lifetime_timer = $LifetimeTimer

var direction = Vector2(0, 0)
var speed = 100.0
var lifetime = 5 # seconds
var hazard_type = "fireball"

func _ready():
	lifetime_timer.wait_time = lifetime
	lifetime_timer.start()

func _process(delta):
	global_position += direction * speed * delta

func _on_area_entered(area):
	queue_free()

func _on_lifetime_timeout():
	queue_free()
