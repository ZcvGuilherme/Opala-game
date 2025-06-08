extends CanvasLayer
@onready var color_rect: ColorRect = $color_rect
func _ready() -> void:
	show_new_scene()

func change_scene(packed_scene: PackedScene, delay= 0.5):
	var scene_transition = get_tree().create_tween()	
	scene_transition.tween_property(color_rect, "threshold", 1.0, 0.5).set_delay(delay)
	await scene_transition.finished
	get_tree().change_scene_to_packed(packed_scene)

func show_new_scene():
	var show_transition = get_tree().create_tween()
	show_transition.tween_property(color_rect, "threshold", 0.0, 0.5).from(1.0)
