extends Label


func _ready() -> void:
	GameEvent.update_points.connect(points_updated)


func points_updated() -> void:
	text = str(Global.current_points)
