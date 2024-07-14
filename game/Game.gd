extends Node2D

const OBSTACLE_POS_Y := 250.0
const ACCELERATION := 25
const POINTS_CHECKPOINT := 100
const OBSTACLE_GEN_PERTIOD := 2.5
const OBSTACLE_GEN_DEVIATION = 0.6

var character_scene := preload("res://game/character/Character.tscn")
var game_over_scene := preload("res://ui/game_over/GameOver.tscn")

var obstacles := [
	preload("res://game/obstacles/block/Block.tscn"),
	preload("res://game/obstacles/stump/Stump.tscn"),
	preload("res://game/obstacles/bag/Bag.tscn")
]

var distance_to_next_obstacle := 0
var screen_width := 512.0
var points := 0.0
var next_checkpoint = POINTS_CHECKPOINT
var is_game_started := false
var character_type
var time_to_gen_next_obstacle := 0.0

onready var character: Node2D
onready var hud := $CanvasLayer/HUD
onready var floor_collision := $Floor
onready var tween := $Tween
onready var start_game_position := $StartGamePosition
onready var ui_root := $CanvasLayer

func _ready() -> void:
	screen_width = get_viewport_rect().size.x
	Globals.connect("game_started", self, "start_game")
	Globals.connect("game_over", self, "game_over")
	Globals.connect("character_selected", self, "spawn_character")

func _process(delta: float) -> void:
	if not is_game_started:
		return
	points += delta * 10
	time_to_gen_next_obstacle -= delta
	hud.set_points(floor(points))
	if points > next_checkpoint:
		next_checkpoint += POINTS_CHECKPOINT
		character.speed += ACCELERATION
	if time_to_gen_next_obstacle <= 0:
		generate_obstacle()

func generate_obstacle():
	time_to_gen_next_obstacle = OBSTACLE_GEN_PERTIOD + Globals._rng.randf_range(-OBSTACLE_GEN_DEVIATION, OBSTACLE_GEN_DEVIATION)
	var obstacle_node = obstacles[Globals._rng.randi_range(0, obstacles.size() - 1)].instance()
	obstacle_node.position = Vector2(character.global_position.x + screen_width, OBSTACLE_POS_Y)
	add_child(obstacle_node)
	
func spawn_character(_character_type: int):
	character_type = _character_type
	yield(get_tree().create_timer(Globals.UI_AMINATION_DURATION), "timeout")
	character = character_scene.instance()
	character.set_character_type(character_type)
	character.global_position = start_game_position.global_position
	floor_collision._follow_target = character
	add_child(character)
#	tween.interpolate_property(character, "global_position", spawn_position, start_game_position.global_position, 
#		Globals.UI_AMINATION_DURATION, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
#	tween.start()
#	yield(tween, "tween_completed")
	Globals.emit_signal("game_started")

func start_game():
	is_game_started = true
	distance_to_next_obstacle += character.global_position.x
	points = 0

func game_over():
	is_game_started = false
	var game_over_overlay = game_over_scene.instance()
	ui_root.add_child(game_over_overlay)
	Ysdk.update_player_score(points)
	points = 0.0
	get_tree().paused = true
