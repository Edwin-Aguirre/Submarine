extends Node


signal update_collected_people_count


func emit_update_collected_people_count() -> void:
	update_collected_people_count.emit()
