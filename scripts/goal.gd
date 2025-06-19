extends Area2D

@export var next_level : String = ""
var next_scene = PackedScene
var activated := false

func _ready() -> void:
	if next_level != "":
		next_scene = ResourceLoader.load(next_level)
		if next_scene == null:
			print("erro ao carregar a cena", next_level)
	
func _on_body_entered(body: Node2D) -> void:
	if activated:
		return 
	if body.name == "Player" and next_scene:
		activated = true
		RespawnTransition.change_scene(next_scene)
	else:
		print("no scene loaded")
