extends Node2D

enum DIRECTION {RIGHT, DOWN, LEFT, UP}

@export var shoot_cooldown := 2.0
@export var shot_direction : DIRECTION = DIRECTION.UP

@onready var anim_sprites: AnimatedSprite2D = $anim_sprites
@onready var shoot_timer: Timer = $shoot_timer
@onready var marcador: Marker2D = $marcador

var bullet = preload("res://scenes/bullet.tscn")

func _ready() -> void:
	shoot_timer.wait_time = shoot_cooldown
	update_marker_position()
func shoot():
	var bullet_instance = bullet.instantiate()as Node2D
	bullet_instance.direction = shot_direction
	bullet_instance.global_position = marcador.global_position
	get_parent().add_child(bullet_instance)
func _on_shoot_timer_timeout() -> void:
	anim_sprites.play("shooting")

func update_marker_position():
	match shot_direction:
		DIRECTION.UP:
			marcador.position = Vector2(-2, -10)
		DIRECTION.DOWN:
			marcador.position = Vector2(2, -20)
		DIRECTION.RIGHT:
			marcador.position = Vector2(7, -13)
		DIRECTION.LEFT:
			marcador.position = Vector2(-7, -20)


func _on_anim_sprites_animation_finished() -> void:
	match anim_sprites.animation:
		"shooting":
			shoot()
			anim_sprites.play("after_shot")
		"after_shot":
			anim_sprites.play("idle")  # ou outra animação que você quiser
