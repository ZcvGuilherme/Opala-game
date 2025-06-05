extends CharacterBody2D

@onready var animacaoPlayer = $AnimacaoPlayer
@export var ghost_trail_scene : PackedScene

const SPEED := 200
const ACCELERATION := 1200
const FRICTION := 2000	
const JUMP_VELOCITY = -350.0
const GRAVITY := 1000
const DASH_SPEED := 500
const DASH_TIME := 0.2
const DASH_VERTICAL_MULTIPLIER := 0.7
const DASH_HORIZONTAL_MULTIPLIER := 1

var isDashing = false
var dashDirection := Vector2.ZERO
var canDash := true
var ghost_timer : float = 0.0
var ghost_interval : float = 0.03
var dash_timer := 0.0

func _physics_process(delta: float) -> void:
	var move_input := Input.get_vector("left", "right", "up", "down")
	
	if isDashing:
		dash_timer -= delta
		ghost_timer -= delta
		
		if ghost_timer <= 0:
			ghost_timer = ghost_interval
			spawn_ghost_trail()
			
		velocity = Vector2(
			dashDirection.x * DASH_SPEED * DASH_HORIZONTAL_MULTIPLIER,
			dashDirection.y * DASH_SPEED * DASH_VERTICAL_MULTIPLIER
		)
		if dashDirection.y == 0:
			velocity.y = 0
		if dash_timer <= 0 :
			isDashing = false
	else:
		if not is_on_floor():
			velocity.y += GRAVITY * delta
	if is_on_floor() and not isDashing :
		canDash = true
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= 0.5
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if Input.is_action_just_pressed("dash") and not isDashing and canDash:
		handle_dash(move_input)
	
	if !isDashing:
		if move_input.x != 0:
			velocity.x = move_toward(velocity.x, move_input.x * SPEED, ACCELERATION * delta)
		else:
			velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
	
	handle_animation(move_input.x)
	move_and_slide()

func handle_jump_animation(direction: float) -> void:
	animacaoPlayer.flip_h = direction < 0 
	if velocity.y < 0:
		if animacaoPlayer.animation != "jump_up":
			animacaoPlayer.play("jump_up")
	elif velocity.y >= 0:
		if animacaoPlayer.animation != "jump_down":
			animacaoPlayer.play("jump_down")

func handle_animation(direction: float) -> void:
	if isDashing:
		animacaoPlayer.play("dash")
	elif not is_on_floor():
		handle_jump_animation(direction)
	elif direction != 0:
		animacaoPlayer.play("run")
		animacaoPlayer.flip_h = direction < 0
	else:
		animacaoPlayer.play("idle")

func handle_dash(move_input: Vector2) -> void:
	canDash = false
	isDashing = true
	dash_timer = DASH_TIME
	ghost_timer = 0.0
	
	if move_input == Vector2.ZERO:
		dashDirection = Vector2.LEFT if animacaoPlayer.flip_h else Vector2.RIGHT
	else: 
		dashDirection = move_input.normalized()

func spawn_ghost_trail():
	var ghost = ghost_trail_scene.instantiate()
	ghost.global_position = global_position
	ghost.rotation = rotation
	ghost.scale = scale
	get_parent().add_child(ghost)
	ghost.setup(animacaoPlayer)

func die():
	global_position = Vector2(100, 200)  # Posição segura
