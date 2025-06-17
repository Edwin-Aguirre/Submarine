extends Area2D


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player"):
		if Global.saved_people_count == 7:
			GameEvent.emit_full_crew_oxygen_refuel()
			print("Full crew refuel")
		else:
			GameEvent.emit_less_people_oxygen_refuel()
			print("Refueled too early")
