extends Area2D

var direction = Vector2(0, 0)
var speed = 100.0
var hazard_type = "fireball"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position += direction * speed * delta

func _on_area_entered(area):
	queue_free()
