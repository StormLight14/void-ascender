extends CharacterBody2D

enum {
	IDLE,
	RUNNING,
	CLIMBING,
}

const MAX_SPEED = 150.0
const JUMP_VELOCITY = -275.0
const CLIMB_SPEED = 75.0
const MAX_STAMINA = 1500
const ACCELERATION = 850.0
const AIR_ACCELERATION = 600.0
const DECELERATION = 850.0
const AIR_DECELERATION = 475.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var state = IDLE
var player_stamina = MAX_STAMINA
var exhausted = false

@onready var climb_checker_left = %ClimbCheckerLeft
@onready var climb_checker_right = %ClimbCheckerRight
@onready var progress_bar = %ProgressBar
@onready var hearts = %Hearts
@onready var stamina_timer = %StaminaTimer
@onready var animated_sprite_2d = %AnimatedSprite2D

signal killed

func _ready():
	animated_sprite_2d.play("idle")
	update_climb_ui()
	#update_hearts()

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
	animated_sprite_2d.play("idle")
	
	handle_movement(delta)
	handle_facing()
	handle_jump()
	handle_gravity(delta, 1)
	handle_stamina(delta)
	
func state_running(delta):
	if velocity.x:
		animated_sprite_2d.play("running")
	else:
		animated_sprite_2d.play("stopped")
	handle_movement(delta)
	handle_jump()
	handle_facing()
	handle_gravity(delta, 1)
	handle_stamina(delta)
	
func state_climbing(delta):
	if animated_sprite_2d.animation != "climbing":
		animated_sprite_2d.play("climbing")
	handle_climbing(delta)
	handle_facing()
	
func handle_stamina(delta):
	if player_stamina < 0:
		player_stamina = 0
		exhausted = true
		stamina_timer.start()
	if is_on_floor() and not exhausted:
		if player_stamina < MAX_STAMINA:
			player_stamina += 1500 * delta
		else:
			player_stamina = MAX_STAMINA
		update_climb_ui()
	
func handle_climbing(delta):
	var left_has_wall = climb_checker_left.is_colliding()
	var right_has_wall = climb_checker_right.is_colliding()
	var on_wall = left_has_wall or right_has_wall
	
	if Input.is_action_pressed("climb") and on_wall and not is_on_floor() and player_stamina > 0 and not exhausted:
		if state != CLIMBING:
			state = CLIMBING
			
		if Input.is_action_just_pressed("jump"):
			if player_stamina >= 50:
				velocity.y = JUMP_VELOCITY / 1.1
				if left_has_wall:
					velocity.x = -JUMP_VELOCITY / 1.4
					animated_sprite_2d.flip_h = false
				elif right_has_wall:
					velocity.x = JUMP_VELOCITY / 1.4
					animated_sprite_2d.flip_h = true
				# player_stamina -= 50
				state = IDLE
		elif left_has_wall and Input.is_action_pressed("left") or right_has_wall and Input.is_action_pressed("right"):
			velocity.y = -CLIMB_SPEED
			player_stamina -= 250 * delta
		elif left_has_wall and Input.is_action_pressed("right") or right_has_wall and Input.is_action_pressed("left"):
			velocity.y = CLIMB_SPEED
			player_stamina -= 250 * delta
		else:
			player_stamina -= 250 * delta
			velocity.y = move_toward(velocity.y, 0, ACCELERATION * delta)
			
		update_climb_ui()
	else:
		if state == CLIMBING:
			state = IDLE
		
func update_climb_ui():
	progress_bar.value = player_stamina
	
func handle_movement(delta):
	var acceleration = ACCELERATION
	var deceleration = DECELERATION
	var max_speed = MAX_SPEED
	if not is_on_floor():
		acceleration = AIR_ACCELERATION
		deceleration = AIR_DECELERATION
	if exhausted:
		acceleration /= 2
		max_speed /= 2
	
	var direction = Input.get_axis("left", "right")

	if direction and state != CLIMBING:
		if Dialogic.current_timeline == null:
			state = RUNNING
			velocity.x = move_toward(velocity.x, max_speed * direction, acceleration * delta)
	else:
		if %IdleTimer.is_stopped():
			%IdleTimer.start()
			animated_sprite_2d.play("stopped")
		velocity.x = move_toward(velocity.x, 0, deceleration * delta)
		
func handle_facing():
	if state == CLIMBING:
		if climb_checker_left.is_colliding():
			animated_sprite_2d.flip_h = true
		elif climb_checker_right.is_colliding():
			animated_sprite_2d.flip_h = false
	else:
		if Input.is_action_pressed("left"):
			animated_sprite_2d.flip_h = true
		if Input.is_action_pressed("right"):
			animated_sprite_2d.flip_h = false
	
func handle_jump():
	if Input.is_action_pressed("jump") and is_on_floor() and Dialogic.current_timeline == null:
		velocity.y = JUMP_VELOCITY

func handle_gravity(delta, gravity_scale):
	if not is_on_floor():
		velocity.y += gravity * gravity_scale * delta

func start_broadcast(messages, seconds, font_size, offset):
	%BroadcastLabel.text = messages[0]
	%BroadcastLabel.set("theme_override_font_sizes/font_size", font_size)
	%BroadcastLabel.set("position", Vector2(0 + offset.x, 121 + offset.y))
	%BroadcastTimer.wait_time = seconds
	%BroadcastTimer.start()
	%AnimationPlayer.play("broadcast_fade_in")
	
func _on_broadcast_timer_timeout():
	%AnimationPlayer.play("broadcast_fade_out")

func _on_hurtbox_area_entered(area):
	killed.emit()

func _on_idle_timer_timeout():
	state = IDLE

func _on_stamina_timer_timeout():
	exhausted = false
	player_stamina = MAX_STAMINA


func _on_hurtbox_body_entered(body):
	killed.emit()
