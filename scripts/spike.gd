extends Area2D
@export var region_width: int = 32
@export var active_duration: float = 1.0
@export var repeat_interval: float = 2.0

@onready var sprite_2d: Sprite2D = $Sprite2D 
@onready var collision: CollisionShape2D = $Collision 
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var timer: Timer = $Timer

func _ready() -> void:
	animation_player.animation_finished.connect(_on_animation_player_animation_finished)
	timer.wait_time = repeat_interval
	timer.timeout.connect(_on_timer_timeout)
	if repeat_interval == 0:
		animation_player.play("idle")
		timer.stop()
	else:
		timer.start()
	
	var region = sprite_2d.region_rect
	region.size.x = region_width
	sprite_2d.region_rect = region
	collision.shape.size = Vector2(region_width, collision.shape.size.y)

	
func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		print("player entrou")
		body.die()


func _on_timer_timeout() -> void:
	animation_player.play("activate")

func deactive():
	animation_player.play("deactivate")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "activate":
		animation_player.play("idle")
		get_tree().create_timer(active_duration).timeout.connect(deactive)
	elif anim_name == "deactivate":
		if repeat_interval > 0:
			timer.start()
