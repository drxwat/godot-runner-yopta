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

var frames := {
	Globals.CharacterType.BEAR: preload("res://game/character/BearFrames.tres"),
	Globals.CharacterType.BABKA: preload("res://game/character/BabkaFrames.tres"),
	Globals.CharacterType.GOP: preload("res://game/character/GopFrames.tres"),
}

func _ready() -> void:
	gravity = 2 * max_jump_height / pow(jump_duration, 2)
	max_jump_velocity = -sqrt(2 * gravity * max_jump_height)
	min_jump_velocity = -sqrt(2 * gravity * min_jump_height)

func _physics_process(delta: float) -> void:
	if not Globals.is_game_started:
		return
	velocity.x = speed
	velocity.y += gravity * delta
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = max_jump_velocity
	
	if Input.is_action_just_released("jump") and velocity.y < min_jump_velocity:
		velocity.y = min_jump_velocity
		
	velocity = move_and_slide(velocity, Vector2.UP)

func set_character_type(character_type: int):
	var animated_sprite := $AnimatedSprite
	var sprite_frames = frames.get(character_type, frames[0])
	animated_sprite.frames = sprite_frames
	animated_sprite.animation = "run"
	animated_sprite.play()


func _on_ObstacleArea2D_body_entered(body: Obstacle) -> void:
	Globals.emit_signal("game_over")
