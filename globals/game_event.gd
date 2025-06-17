extends Node


signal update_collected_people_count
signal full_crew_oxygen_refuel
signal less_people_oxygen_refuel


func emit_update_collected_people_count() -> void:
	update_collected_people_count.emit()


func emit_full_crew_oxygen_refuel() -> void:
	full_crew_oxygen_refuel.emit()


func emit_less_people_oxygen_refuel() -> void:
	less_people_oxygen_refuel.emit()
