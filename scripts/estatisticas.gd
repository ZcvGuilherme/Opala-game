extends Control
@onready var tempo_fase_1: Label = $tempo_fase1
@onready var tempo_fase_2: Label = $tempo_fase2
@onready var tempo_fase_3: Label = $tempo_fase3
@onready var death_counter: Label = $death_counter
@onready var tempo_total: Label = $tempo_total


func _ready() -> void:
	get_timer_phases()
	get_death_counter()
func get_timer_phases():
	var total_minutes = Globals.minute_fase1 + Globals.minute_fase2 + Globals.minute_fase3
	var total_seconds = Globals.second_fase1 + Globals.second_fase2 + Globals.second_fase3
	
	total_minutes += int(total_seconds / 60)
	total_seconds = total_seconds % 60
	
	tempo_fase_1.text = "Fase 1: "+ str("%02d" % Globals.minute_fase1) + ":" + str("%02d" % Globals.second_fase1)
	tempo_fase_2.text = "Fase 2: " + str("%02d" % Globals.minute_fase2) + ":" + str("%02d" % Globals.second_fase2)
	tempo_fase_3.text = "Fase 3: " + str("%02d" % Globals.minute_fase3) + ":" + str("%02d" % Globals.second_fase3)

	tempo_total.text = "Tempo Total: " + str("%02d" % total_minutes) + ":" + str("%02d" % total_seconds)
	
func get_death_counter():
	death_counter.text = "%03d" % Globals.death_count
