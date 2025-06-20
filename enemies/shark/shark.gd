extends Area2D


const SPEED: int = 50
const MOVEMENT_FREQUENCY: float = 0.15
const MOVEMENT_AMPLITUDE: float = 0.5
const PIECE_COUNT: int = 2
const SHARK_DEATH = preload("res://enemies/shark/shark_death.ogg")
const OBJECT_PIECE = preload("res://particles/object_piece/object_piece.tscn")
const POINT_VALUE_POPUP = preload("res://user_interface/points_value_popup/point_value_popup.tscn")


var velocity: Vector2 = Vector2.RIGHT
var random_offset: float = randf_range(0.0, 10.0)
var points_value: int = 25
var current_state = states.DEFAULT


enum states {DEFAULT, PAUSED}


@onready var shark_sprite: AnimatedSprite2D = $SharkSprite


func _ready() -> void:
	GameEvent.pause_enemies.connect(paused)
	GameEvent.kill_all_enemies.connect(_death)


func _physics_process(delta: float) -> void:
	if current_state == states.DEFAULT:
		velocity.y = sin(global_position.x * MOVEMENT_FREQUENCY + random_offset) * MOVEMENT_AMPLITUDE
		global_position += velocity * SPEED * delta


func _process(_delta: float) -> void:
	if global_position.x > Global.SCREEN_BOUND_MAX_X or global_position.x < Global.SCREEN_BOUND_MIN_X:
		queue_free()


func flip_shark_direction() -> void:
	velocity = -velocity
	shark_sprite.flip_h = !shark_sprite.flip_h


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


func shark_death_pieces() -> void:
	for i in range(PIECE_COUNT):
		var shark_pieces_instance = OBJECT_PIECE.instantiate()
		shark_pieces_instance.frame = i
		
		get_tree().current_scene.add_child(shark_pieces_instance)
		shark_pieces_instance.global_position = global_position


func _death() -> void:
	Global.current_points += points_value
	GameEvent.emit_update_points()
	SoundManager.play_sound(SHARK_DEATH)
	shark_death_pieces()
	point_popup()
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("PlayerBullet"):
		area.queue_free()
		_death()
	
	if area.is_in_group("Player"):
		area.death()
