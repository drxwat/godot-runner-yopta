extends KinematicBody2D

const UNIT_HEIGHT = 64.0

var speed := 150.0 
var max_jump_height = 1.2 * UNIT_HEIGHT
var min_jump_height = 0.5 * UNIT_HEIGHT
var jump_duration = 0.9

var velocity := Vector2.RIGHT * speed
var gravity: float
var max_jump_velocity: float
var min_jump_velocity: float


func _ready() -> void:
	gravity = 2 * max_jump_height / pow(jump_duration, 2)
	max_jump_velocity = -sqrt(2 * gravity * max_jump_height)
	min_jump_velocity = -sqrt(2 * gravity * min_jump_height)

func _physics_process(delta: float) -> void:
	velocity.x = speed
	velocity.y += gravity * delta
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = max_jump_velocity
	
	if Input.is_action_just_released("jump") and velocity.y < min_jump_velocity:
		velocity.y = min_jump_velocity
		
	velocity = move_and_slide(velocity, Vector2.UP)

