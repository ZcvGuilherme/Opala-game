extends Area2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer



func _ready() -> void:
	# Conecta o sinal pra saber quando uma animação acabou
	animation_player.animation_finished.connect(_on_animation_finished)
	# Começa pelo activate
	animation_player.play("activating")

func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "activating":
		# Quando o activate finalizar, tocamos o active
		animation_player.play("active")
	elif anim_name == "active":
		animation_player.play("deactivate")
