extends CharacterBody2D

@onready var animacaoPlayer = $AnimacaoPlayer

const SPEED := 200
const ACCELERATION := 1200
const FRICTION := 2000
const JUMP_VELOCITY = -350.0
const GRAVITY := 1000

func handle_animation(direction: float) -> void:
	if direction != 0:
		animacaoPlayer.play("run")
		animacaoPlayer.flip_h = direction < 0
	else:
		animacaoPlayer.play("idle")
		
	if not is_on_floor():
		animacaoPlayer.play("idle")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	# Handle jump
	if Input.is_action_just_released("ui_accept") and velocity.y < 0:
		velocity.y *= 0.5
	
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = move_toward(velocity.x, direction * SPEED, ACCELERATION * delta)
	else:
		if abs(velocity.x) < 10:
			velocity.x = 0
		else:
			velocity.x = move_toward(velocity.x, 0, FRICTION * delta)

	handle_animation(direction)
	move_and_slide()
	
