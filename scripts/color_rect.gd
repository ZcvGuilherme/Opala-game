extends ColorRect

var radius = 1.0

func _process(delta: float) -> void:
	material.set("shader_parameter/radius", radius)
	
