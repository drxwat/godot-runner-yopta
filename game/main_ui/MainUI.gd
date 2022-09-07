extends MarginContainer

onready var tween := $Tween
onready var character_selector := $VBoxContainer/CharacterSelectorContainer

func _ready() -> void:
#	Globals.connect("game_started", self, "remove_ui")
	Globals.connect("character_selected", self, "remove_ui")

func remove_ui(character_type: int):
	tween.interpolate_property(character_selector, "rect_position", character_selector.rect_position, 
		Vector2(0, -120), Globals.UI_AMINATION_DURATION, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	tween.start()
