extends Area2D

@export var trigger_limit = 1
@export var set_gravity_scale = 1.0

func _on_body_entered(body):
	trigger_limit -= 1
	if trigger_limit <= 0:
		queue_free()
		
	body.player_gravity_scale = set_gravity_scale

func _on_area_entered(area):
	pass # Replace with function body.
	
