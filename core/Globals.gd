extends Node

var _rng := RandomNumberGenerator.new()

func _ready() -> void:
	_rng.randomize()
	print_debug("seed: " + str(_rng.seed))
