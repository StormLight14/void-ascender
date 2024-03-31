extends CharacterBody2D

const MAX_SPEED = 150.0
const ACCELERATION = 850.0
const JUMP_VELOCITY = -275.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var player_hearts = 3
@onready var hearts = %Hearts

signal killed

func _ready():
	update_hearts()

func _physics_process(delta):
	handle_jump()
	handle_gravity(delta)
	
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = move_toward(velocity.x, MAX_SPEED * direction, ACCELERATION * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, ACCELERATION * delta)

	move_and_slide()
	
func handle_movement(delta):
	pass
	
func handle_jump():
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

func handle_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

func update_hearts():
	var heart = preload("res://ui/heart.tscn")
	for heart_node in hearts.get_children():
		heart_node.queue_free()
		
	for i in range(player_hearts):
		hearts.add_child(heart.instantiate())

func _on_hurtbox_area_entered(area):
	if area.get_node("Hazard").hazard_type != "void" and player_hearts > 1:
		player_hearts -= 1
		update_hearts()
		return

	killed.emit()
	player_hearts = 3
	update_hearts()
