extends MarginContainer

onready var points_label := $VBoxContainer/HBoxContainer/PointsLabel

func set_points(points: int) -> void:
	points_label.text = "%d" % points
