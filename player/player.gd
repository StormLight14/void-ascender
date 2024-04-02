extends CharacterBody2D

enum {
	IDLE,
	RUNNING,
	CLIMBING,
}

const MAX_SPEED = 150.0
const ACCELERATION = 850.0
const JUMP_VELOCITY = -275.0
const CLIMB_SPEED = 100.0
const STAMINA = 1500 # 1ms of holding takes 1 stamina; 1 ms of climbing takes 2

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var state = IDLE

@onready var climb_checker_left = %ClimbCheckerLeft
@onready var climb_checker_right = %ClimbCheckerRight

@export var player_hearts = 3
@onready var hearts = %Hearts

signal killed

func _ready():
	update_hearts()

func _physics_process(delta):
	match state:
		IDLE:
			state_idle(delta)
		RUNNING:
			state_running(delta)
		CLIMBING:
			state_climbing(delta)

	handle_climbing(delta)
	

	move_and_slide()
	
func state_idle(delta):
	handle_movement(delta)
	handle_jump()
	handle_gravity(delta, 1)
	
func state_running(delta):
	handle_movement(delta)
	handle_jump()
	handle_gravity(delta, 1)
	
func state_climbing(delta):
	handle_climbing(delta)
	
func handle_climbing(delta):
	var left_has_wall = climb_checker_left.is_colliding()
	var right_has_wall = climb_checker_right.is_colliding()
	var on_wall = left_has_wall or right_has_wall
	
	if Input.is_action_pressed("climb") and on_wall and not is_on_floor():
		if state != CLIMBING:
			state = CLIMBING
			
		if Input.is_action_just_pressed("jump"):
			velocity.y = JUMP_VELOCITY / 1.5
			if left_has_wall:
				velocity.x = -JUMP_VELOCITY / 1.5
			elif right_has_wall:
				velocity.x = JUMP_VELOCITY / 1.5
		elif left_has_wall and Input.is_action_pressed("left") or right_has_wall and Input.is_action_pressed("right"):
			velocity.y = -CLIMB_SPEED
		elif left_has_wall and Input.is_action_pressed("right") or right_has_wall and Input.is_action_pressed("left"):
			velocity.y = CLIMB_SPEED
		else:
			velocity.y = move_toward(velocity.y, 0, ACCELERATION * delta)
	else:
		state = IDLE
	
func handle_movement(delta):
	var direction = Input.get_axis("left", "right")
	if direction and state != CLIMBING:
		state = RUNNING
		velocity.x = move_toward(velocity.x, MAX_SPEED * direction, ACCELERATION * delta)
	else:
		state = IDLE
		velocity.x = move_toward(velocity.x, 0, ACCELERATION * delta)
	
func handle_jump():
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

func handle_gravity(delta, gravity_scale):
	if not is_on_floor():
		velocity.y += gravity * gravity_scale * delta

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
