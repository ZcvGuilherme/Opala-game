extends Area2D
@export var region_width: int = 32

@onready var sprite_2d: Sprite2D = $Sprite2D 
@onready var collision: CollisionShape2D = $Collision 
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	var region = sprite_2d.region_rect
	region.size.x = region_width
	sprite_2d.region_rect = region
	collision.shape.size = Vector2(region_width, collision.shape.size.y)

	animation_player.play("idle")

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		print("player entrou")
		body.die()
