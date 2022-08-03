extends Node

const UI_AMINATION_DURATION = 1.5

enum CharacterType { BEAR, BABKA, GOP }

signal game_started
signal game_over
signal character_selected(character_type)

var _rng := RandomNumberGenerator.new()
var max_points := 0
var is_game_started := false

func _ready() -> void:
	_rng.randomize()
	print_debug("seed: " + str(_rng.seed))
