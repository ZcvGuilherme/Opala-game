extends Control
@onready var tempo_fase_1: Label = $tempo_fase1
@onready var tempo_fase_2: Label = $tempo_fase2
@onready var tempo_fase_3: Label = $tempo_fase3
@onready var death_counter: Label = $death_counter


func _ready() -> void:
	get_timer_phases()
	get_death_counter()
func get_timer_phases():
	tempo_fase_1.text = "Fase 1: "+ str("%02d" % Globals.minute_fase1) + ":" + str("%02d" % Globals.second_fase1)
	tempo_fase_2.text = "Fase 2: " + str("%02d" % Globals.minute_fase2) + ":" + str("%02d" % Globals.second_fase2)
	tempo_fase_3.text = "Fase 3: " + str("%02d" % Globals.minute_fase3) + ":" + str("%02d" % Globals.second_fase3)

func get_death_counter():
	death_counter.text = "%03d" % Globals.death_count
