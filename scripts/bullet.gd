extends AnimatedSprite2D

enum DIRECTION {RIGHT, DOWN, LEFT, UP}

var speed : int = 1000
var direction : int
var exploded := false
func _ready() -> void:
	match direction:
		DIRECTION.RIGHT:
			play("right_shot")
		DIRECTION.LEFT:
			play("left_shot")
		DIRECTION.UP:
			play("up_shot")
		DIRECTION.DOWN:
			play("down_shot")

func _physics_process(delta: float) -> void:
	if exploded:
		return
	
	match direction:
		DIRECTION.RIGHT:
			position.x += speed * delta
		DIRECTION.LEFT:
			position.x -= speed * delta
		DIRECTION.UP:
			position.y -= speed * delta
		DIRECTION.DOWN:
			position.y += speed * delta
	
func _on_timer_timeout() -> void:
	queue_free()

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.die()
	explode()

func explode():
	play("explosion")
	queue_free()
