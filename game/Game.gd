extends Node2D

const OBSTACLE_POS_Y := 250.0
const ACCELERATION := 25
const POINTS_CHECKPOINT := 100

var character_scene := preload("res://game/character/Character.tscn")

var obstacles := [
	preload("res://game/obstacles/block/Block.tscn"),
	preload("res://game/obstacles/stump/Stump.tscn"),
	preload("res://game/obstacles/bag/Bag.tscn")
]

var distance_to_next_obstacle := 0
var screen_width := 512.0
var points := 0.0
var next_checkpoint = POINTS_CHECKPOINT

onready var character: Node2D
onready var hud := $CanvasLayer/HUD
onready var floor_collision := $Floor
onready var tween := $Tween
onready var start_game_position := $StartGamePosition

func _ready() -> void:
	screen_width = get_viewport_rect().size.x
	Globals.connect("game_started", self, "start_game")
	Globals.connect("game_over", self, "game_over")
	Globals.connect("character_selected", self, "spawn_character")

func _process(delta: float) -> void:
	if not Globals.is_game_started:
		return
	points += delta * 10
	hud.set_points(floor(points))
	if points > next_checkpoint:
		next_checkpoint += POINTS_CHECKPOINT
		character.speed += ACCELERATION
	if  character.global_position.x > distance_to_next_obstacle:
		generate_obstacle()

func generate_obstacle():
	distance_to_next_obstacle = character.global_position.x + screen_width
	var obstacle_node = obstacles[Globals._rng.randi_range(0, obstacles.size() - 1)].instance()
	obstacle_node.position = Vector2(character.global_position.x + screen_width, OBSTACLE_POS_Y)
	add_child(obstacle_node)
	
func spawn_character(character_type: int):
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
	Globals.is_game_started = true
	distance_to_next_obstacle += character.global_position.x
	points = 0

func game_over():
	Ysdk.update_player_score(points)
	points = 0.0
