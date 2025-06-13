extends Node2D
@onready var a_d: AnimatedSprite2D = $"A-D"
@onready var d: AnimatedSprite2D = $D
@onready var space: AnimatedSprite2D = $SPACE
@onready var shift: AnimatedSprite2D = $SHIFT
@onready var w: AnimatedSprite2D = $W

func _ready() -> void:
	a_d.play("pressing")
	d.play("default")
	space.play("default")
	shift.play("default")
	w.play("default")
