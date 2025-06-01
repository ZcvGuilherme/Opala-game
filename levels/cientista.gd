extends Sprite2D

var resource = load("res://Dialoges/Cientsts_dialogues.dialogue")
# then
var dialogue_line = await DialogueManager.get_next_dialogue_line(resource, "start")
