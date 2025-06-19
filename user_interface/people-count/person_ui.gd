extends Sprite2D


const PERSON_EMPTY_UI = preload("res://user_interface/people-count/person_empty_ui.png")
const PERSON_UI = preload("res://user_interface/people-count/person_ui.png")


@export var order_number: int = 1


func _ready() -> void:
	GameEvent.update_collected_people_count.connect(_update)


func _update() -> void:
	if Global.saved_people_count >= 7:
		frame = 1
	else:
		frame = 0
	
	if Global.saved_people_count >= order_number:
		texture = PERSON_UI
	else:
		texture = PERSON_EMPTY_UI
