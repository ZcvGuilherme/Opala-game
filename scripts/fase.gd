extends Node2D

func set_current_time(mins: int, secs: int) -> void:
	var scene_name = get_tree().current_scene.name
	
	match scene_name:
		"Tutorial":
			Globals.minute_tutorial = mins
			Globals.second_tutorial = secs
		"Fase1":
			Globals.minute_fase1 = mins
			Globals.second_fase1 = secs
		"Fase2":
			Globals.minute_fase2 = mins
			Globals.second_fase2 = secs
		"Fase3":
			Globals.minute_fase3 = mins
			Globals.second_fase3 = secs
		_:
			push_warning("Nome da cena não reconhecido: " + scene_name)
