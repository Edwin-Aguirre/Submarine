extends Node


signal update_collected_people_count
signal update_points
signal full_crew_oxygen_refuel
signal less_people_oxygen_refuel
signal game_over
signal camera_follow_player(y_position: float)


func emit_update_collected_people_count() -> void:
	update_collected_people_count.emit()


func emit_update_points() -> void:
	update_points.emit()


func emit_full_crew_oxygen_refuel() -> void:
	full_crew_oxygen_refuel.emit()


func emit_less_people_oxygen_refuel() -> void:
	less_people_oxygen_refuel.emit()


func emit_game_over() -> void:
	game_over.emit()


func emit_camera_follow_player(y_position: float) -> void:
	camera_follow_player.emit(y_position)
