extends MarginContainer

onready var tween := $Tween
onready var character_selector := $VBoxContainer/CharacterSelectorContainer
onready var top_score := $VBoxContainer/TOPScore
onready var mini_leaderboard := $VBoxContainer/MiniLeaderboard

func _ready() -> void:
	Globals.connect("character_selected", self, "remove_ui")

func remove_ui(character_type: int):
	tween.interpolate_property(character_selector, "rect_position", character_selector.rect_position, 
		Vector2(0, -120), Globals.UI_AMINATION_DURATION, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	tween.interpolate_property(top_score, "rect_position", top_score.rect_position, 
		Vector2(0, -120), Globals.UI_AMINATION_DURATION, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	tween.interpolate_property(mini_leaderboard, "rect_position", mini_leaderboard.rect_position, 
		Vector2(0, 240), Globals.UI_AMINATION_DURATION, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	tween.start()
	yield(tween, "tween_all_completed")
	character_selector.visible = false
	mini_leaderboard.visible = false
	top_score.visible = false
