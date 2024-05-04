extends CharacterBody2D

enum {
	IDLE,
	RUNNING,
	CLIMBING,
}

const MAX_SPEED = 150.0
const ACCELERATION = 850.0
const JUMP_VELOCITY = -275.0
const CLIMB_SPEED = 75.0
const MAX_STAMINA = 1500

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var state = IDLE
var player_stamina = MAX_STAMINA

var broadcast_data = [[""], 0]

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
	handle_gravity(delta, 1)
	handle_stamina(delta)
	
func state_climbing(delta):
	if animated_sprite_2d.animation != "climbing":
		animated_sprite_2d.play("climbing")
	handle_climbing(delta)
	
func handle_stamina(delta):
	if player_stamina < 0:
		player_stamina = 0
		stamina_timer.start()
	if is_on_floor() and stamina_timer.is_stopped():
		if player_stamina < MAX_STAMINA:
			player_stamina += 500 * delta
		else:
			player_stamina = MAX_STAMINA
		update_climb_ui()
	
func handle_climbing(delta):
	var left_has_wall = climb_checker_left.is_colliding()
	var right_has_wall = climb_checker_right.is_colliding()
	var on_wall = left_has_wall or right_has_wall
	
	if Input.is_action_pressed("climb") and on_wall and not is_on_floor() and player_stamina > 0 and stamina_timer.is_stopped():
		if state != CLIMBING:
			state = CLIMBING
			
		if Input.is_action_just_pressed("jump"):
			if player_stamina >= 200:
				velocity.y = JUMP_VELOCITY / 1.5
				if left_has_wall:
					velocity.x = -JUMP_VELOCITY / 1.5
				elif right_has_wall:
					velocity.x = JUMP_VELOCITY / 1.5
				player_stamina -= 200
		elif left_has_wall and Input.is_action_pressed("left") or right_has_wall and Input.is_action_pressed("right"):
			velocity.y = -CLIMB_SPEED
			player_stamina -= 200 * delta
		elif left_has_wall and Input.is_action_pressed("right") or right_has_wall and Input.is_action_pressed("left"):
			velocity.y = CLIMB_SPEED
			player_stamina -= 200 * delta
		else:
			player_stamina -= 100 * delta
			velocity.y = move_toward(velocity.y, 0, ACCELERATION * delta)
			
		update_climb_ui()
		
func update_climb_ui():
	progress_bar.value = player_stamina
	
func handle_movement(delta):
	var direction = Input.get_axis("left", "right")
	if Input.is_action_just_pressed("left"):
		animated_sprite_2d.flip_h = true
	if Input.is_action_just_pressed("right"):
		animated_sprite_2d.flip_h = false
	if direction and state != CLIMBING:
		if Dialogic.current_timeline == null:
			state = RUNNING
			velocity.x = move_toward(velocity.x, MAX_SPEED * direction, ACCELERATION * delta)
	else:
		if %IdleTimer.is_stopped():
			%IdleTimer.start()
			animated_sprite_2d.play("stopped")
		velocity.x = move_toward(velocity.x, 0, ACCELERATION * delta)
	
func handle_jump():
	if Input.is_action_pressed("jump") and is_on_floor() and Dialogic.current_timeline == null:
		velocity.y = JUMP_VELOCITY

func handle_gravity(delta, gravity_scale):
	if not is_on_floor():
		velocity.y += gravity * gravity_scale * delta

"""
func update_hearts():
	var heart = preload("res://ui/heart.tscn")
	for heart_node in hearts.get_children():
		heart_node.queue_free()
		
	for i in range(player_hearts):
		hearts.add_child(heart.instantiate())
"""

func start_broadcast(messages, font_size, seconds, offset):
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
	player_stamina = MAX_STAMINA
