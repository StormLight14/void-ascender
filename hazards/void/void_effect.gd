extends Sprite2D

var SPEED = 10.0

var velocity = Vector2.ZERO
var rng = RandomNumberGenerator.new()
var positions = []

func _ready():
	velocity *= Vector2(randf_range(0.9, 1.1), randf_range(0.9, 1.1))

func _process(delta):
	global_position += velocity * SPEED * delta
