extends Area2D

@onready var lifetime_timer = $LifetimeTimer
@onready var cpu_particles_2d = $CPUParticles2D

var direction = Vector2(0, 0)
var speed = 100.0
var lifetime = 3 # seconds

func _ready():
	cpu_particles_2d.direction = direction
	lifetime_timer.wait_time = lifetime
	lifetime_timer.start()

func _process(delta):
	global_position += direction * speed * delta

func _on_area_entered(area):
	queue_free()

func _on_lifetime_timeout():
	queue_free()
