extends CanvasLayer
@onready var color_rect: ColorRect = $color_rect

func _ready() -> void:
	show_new_scene()

func change_scene(packed_scene: PackedScene, delay := 0.5):
	var tween = get_tree().create_tween()
	tween.tween_property(
		color_rect.material, "shader_parameter/radius", 0.0, 1.0
	).set_delay(delay)
	await tween.finished
	get_tree().change_scene_to_packed(packed_scene)

func show_new_scene():
	var tween = get_tree().create_tween()
	tween.tween_property(
		color_rect.material, "shader_parameter/radius", 1.5, 0.5
	).from(0.0).set_delay(0.2)
