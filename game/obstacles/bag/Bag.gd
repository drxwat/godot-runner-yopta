extends Obstacle

var rotation_speed := 35.0
var max_height_deviation := 80.0
var max_speed := 50.0
var speed := 0.0

onready var sprite := $Sprite

func _ready() -> void:
	var position_shift = Globals._rng.randf_range(0, max_height_deviation)
	global_position.y -= max_height_deviation if position_shift > 50.0 else position_shift
	speed = Globals._rng.randf_range(0, max_speed)
	

func _physics_process(delta: float) -> void:
	move_and_slide(Vector2.LEFT * speed)
	sprite.rotation_degrees -= rotation_speed * delta
	
