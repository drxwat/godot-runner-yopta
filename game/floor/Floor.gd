extends StaticBody2D

export var follow_target_path : NodePath
onready var _follow_target: Node2D = get_node(follow_target_path)

func _process(delta: float) -> void:
	if _follow_target:
		global_position.x = _follow_target.global_position.x
