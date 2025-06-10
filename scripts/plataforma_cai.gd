extends AnimatableBody2D

@onready var animação := $animação as AnimationPlayer
@onready var respawn_timer := $respawn_timer as Timer
@onready var respawn_position := $AnimationPlayer

@export var reset_timer := 0.2

var velocity = Vector2.ZERO
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_triggered := false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_physics_process(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _phyaics_process(delta):
	velocity.y += gravity * delta
	position += velocity * delta

func has_collided_with(collisão: KinematicCollision2D, collider: CharacterBody2D):
	if !is_triggered:
		is_triggered = true
		animação.play("shake")
		velocity = Vector2.ZERO


func _on_animação_animation_finished(anim_name: StringName) -> void:
	set_physics_process(true)
	respawn_timer.start(reset_timer)
	
func _on_respawn_timer_timeout() -> void:
	set_physics_process(false)
	$AnimationPlayer.play = respawn_position
	if is_triggered:  
		var spawn_tween = create_tween().set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_IN_OUT)
		spawn_tween.tween_property($textura, "scale", Vector2(1,1), 0.2).from(Vector2(0,0))
	is_triggered = false
