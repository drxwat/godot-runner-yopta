extends Node2D

const OBSTACLE_POS_Y := 250.0
const ACCELERATION := 10

var obstacles := [
	preload("res://game/obstacles/block/Block.tscn"),
	preload("res://game/obstacles/stump/Stump.tscn"),
	preload("res://game/obstacles/bag/Bag.tscn")
]


var _distance_to_next_obstacle := 0
var screen_width := 512.0
var points := 0.0

onready var character := $Character
onready var hud := $CanvasLayer/HUD

func _ready() -> void:
	screen_width = get_viewport_rect().size.x
	_distance_to_next_obstacle += character.global_position.x



func _process(delta: float) -> void:
	points += delta * 10
	hud.set_points(floor(points))
	character.speed += ACCELERATION * delta
	print(character.speed)
	if  character.global_position.x > _distance_to_next_obstacle:
		generate_obstacle()

func generate_obstacle():
	_distance_to_next_obstacle = character.global_position.x + screen_width
	var obstacle_node = obstacles[Globals._rng.randi_range(0, obstacles.size() - 1)].instance()
	obstacle_node.position = Vector2(character.global_position.x + screen_width, OBSTACLE_POS_Y)
	add_child(obstacle_node)

