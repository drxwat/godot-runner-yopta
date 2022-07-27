extends KinematicBody2D
class_name Obstacle

func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()
