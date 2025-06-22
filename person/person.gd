extends Area2D


const SPEED: int = 25
const SAVING_PERSON = preload("res://person/saving_person.ogg")
const PERSON_DEATH = preload("res://person/person_death.ogg")
const POINT_VALUE_POPUP = preload("res://user_interface/points_value_popup/point_value_popup.tscn")


var velocity: Vector2 = Vector2.RIGHT
var points_value: int = 30
var current_state = states.DEFAULT


enum states {DEFAULT, PAUSED}


@onready var person_sprite: AnimatedSprite2D = $PersonSprite


func _ready() -> void:
	GameEvent.pause_enemies.connect(paused)


func _physics_process(delta: float) -> void:
	if current_state == states.DEFAULT:
		global_position += velocity * SPEED * delta


func _process(_delta: float) -> void:
	if global_position.x > Global.SCREEN_BOUND_MAX_X or global_position.x < Global.SCREEN_BOUND_MIN_X:
		queue_free()


func flip_person_direction() -> void:
	velocity = -velocity
	person_sprite.flip_h = !person_sprite.flip_h


func paused(pause: bool) -> void:
	if pause:
		current_state = states.PAUSED
	else:
		current_state = states.DEFAULT


func point_popup() -> void:
	var point_value_popup_instance = POINT_VALUE_POPUP.instantiate()
	
	point_value_popup_instance.value = points_value
	get_tree().current_scene.add_child(point_value_popup_instance)
	point_value_popup_instance.global_position = global_position


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player") and Global.saved_people_count < 7:
		Global.saved_people_count += 1
		GameEvent.emit_update_collected_people_count()
		Global.current_points += points_value
		GameEvent.emit_update_points()
		SoundManager.play_sound(SAVING_PERSON)
		Input.start_joy_vibration(0, 0.25, 0.5, 0.5)
		point_popup()
		queue_free()
	elif area.is_in_group("PlayerBullet"):
		SoundManager.play_sound(PERSON_DEATH)
		area.queue_free()
		queue_free()
