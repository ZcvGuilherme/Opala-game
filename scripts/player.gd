extends CharacterBody2D

@onready var ray_left: RayCast2D = $Ray_Left
@onready var ray_right: RayCast2D = $Ray_Right
@onready var animacaoPlayer = $AnimacaoPlayer
@onready var jump_sfx: AudioStreamPlayer = $jump_sfx
@onready var dash_sfx: AudioStreamPlayer = $dash_sfx
@onready var wall_slide_sfx: AudioStreamPlayer = $"wall-slide_sfx"
@onready var die_sfx: AudioStreamPlayer = $die_sfx
@onready var colisor_player: CollisionShape2D = $"Colisor-Player"

@export var ghost_trail_scene : PackedScene

const SPEED := 200
const ACCELERATION := 1200
const FRICTION := 2000	
const JUMP_VELOCITY = -350.0
const GRAVITY := 1000
const DASH_SPEED := 500
const DASH_TIME := 0.2
const DASH_VERTICAL_MULTIPLIER := 0.7
const DASH_HORIZONTAL_MULTIPLIER := 0.9
const KNOCKBACK_MULTIPLIER := 3

var wall_slide_speed: float = 50.0
var wall_jump_force: Vector2 = Vector2(400, -400)
var isDashing = false
var dashDirection := Vector2.ZERO
var canDash := true
var ghost_timer : float = 0.0
var ghost_interval : float = 0.03
var dash_timer := 0.0
var is_wall_sliding: bool = false
var wall_direction: int = 0
var knockback_vector := Vector2.ZERO
var facing_direction := 1
var checkpoint_manager

func _ready() -> void:
	checkpoint_manager = get_parent().get_node("CheckpointManager")

func _physics_process(delta: float) -> void:
	var move_input := Input.get_vector("left", "right", "up", "down")
	
	var is_touching_left_wall = ray_left.is_colliding()
	var is_touching_right_wall = ray_right.is_colliding()
	var left_collider = ray_left.get_collider()
	var right_collider = ray_right.get_collider()
	
	var can_slide_left = is_touching_left_wall and (left_collider is Node and not left_collider.is_in_group("cannot_slide"))
	var can_slide_right = is_touching_right_wall and (right_collider is Node and not right_collider.is_in_group("cannot_slide"))
	
	if move_input.x != 0:
		facing_direction = sign(move_input.x)
	
	if isDashing:
		dash_timer -= delta
		ghost_timer -= delta
		
		if ghost_timer <= 0:
			ghost_timer += ghost_interval
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
		
	if (can_slide_left or can_slide_right) and not is_on_floor() and velocity.y > 0:
		start_wall_slide(is_touching_left_wall, is_touching_right_wall)
		
	elif is_wall_sliding and not (is_touching_left_wall or is_touching_right_wall) or is_on_floor():
		stop_wall_slide() 
		
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= 0.5
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		jump_sfx.play()
	
	if is_wall_sliding and Input.is_action_just_pressed("jump"):
		velocity = Vector2(wall_jump_force.x * wall_direction, wall_jump_force.y)
		jump_sfx.play()
		stop_wall_slide()
		
	if Input.is_action_just_pressed("dash") and not isDashing and canDash:
		handle_dash(move_input)
		dash_sfx.play()
	
	if !isDashing:
		if move_input.x != 0:
			velocity.x = move_toward(velocity.x, move_input.x * SPEED, ACCELERATION * delta)
		else:
			velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
			
	if knockback_vector != Vector2.ZERO:
		velocity = knockback_vector
	handle_animation()
	move_and_slide()
	
	for platforms in get_slide_collision_count():
		var collision = get_slide_collision(platforms)
		if collision.get_collider().has_method("has_collided_with"):
			collision.get_collider().has_collided_with(collision, self)

func handle_jump_animation() -> void:
	animacaoPlayer.flip_h = facing_direction < 0 
	if velocity.y < 0:
		if animacaoPlayer.animation != "jump_up":
			animacaoPlayer.play("jump_up")
	elif velocity.y >= 0:
		if animacaoPlayer.animation != "jump_down":
			animacaoPlayer.play("jump_down")

func handle_animation() -> void:
	if isDashing:
		animacaoPlayer.play("dash")
	elif is_wall_sliding:
		animacaoPlayer.play("wall_slide")
		animacaoPlayer.flip_h = wall_direction < 0
	elif not is_on_floor() and not is_wall_sliding:
		handle_jump_animation()
	elif velocity.x != 0:
		animacaoPlayer.play("run")
		animacaoPlayer.flip_h = facing_direction < 0
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
	colisor_player.call_deferred("set_disabled", true)
	Globals.death_count += 1
	
	var knockback = Vector2(-facing_direction * 200, -400)
	die_sfx.play()
	await knockback_effect(knockback)
	velocity = Vector2.ZERO
	set_physics_process(false)  
	
	animacaoPlayer.play("death")
	
	await get_tree().create_timer(0.7).timeout
	await RespawnTransition.close_scene(0.1)
	await respawn()
	
func knockback_effect(knockback_force := Vector2.ZERO, duration := 0.25):
	if knockback_force != Vector2.ZERO:
		knockback_vector = knockback_force
		
		var knockback_tween := get_tree().create_tween() 
		knockback_tween.tween_property(self, "knockback_vector", Vector2.ZERO, duration)
		await knockback_tween.finished
	
func respawn():
	global_position = checkpoint_manager.last_location
	velocity = Vector2.ZERO
	
	facing_direction = 1
	animacaoPlayer.flip_h = false
	
	await RespawnTransition.show_new_scene()
	
	animacaoPlayer.play("awake")
	await animacaoPlayer.animation_finished

	set_physics_process(true)  
	
	colisor_player.disabled = false
	
func start_wall_slide(left, right):
	is_wall_sliding = true
	
	canDash = true
	velocity.y = min(velocity.y, wall_slide_speed)
	wall_direction = 1	if left else -1
	if not wall_slide_sfx.playing:
		wall_slide_sfx.play()
	
func stop_wall_slide():
	if wall_slide_sfx.playing:
		wall_slide_sfx.stop()
	is_wall_sliding = false
	wall_direction = 0
