extends Area2D


const SPEED: int = 50
const MOVEMENT_FREQUENCY: float = 0.15
const MOVEMENT_AMPLITUDE: float = 0.5
const SHARK_DEATH = preload("res://enemies/shark/shark_death.ogg")


var velocity: Vector2 = Vector2.RIGHT
var random_offset: float = randf_range(0.0, 10.0)
var points_value: int = 25
var current_state = states.DEFAULT


enum states {DEFAULT, PAUSED}


@onready var shark_sprite: AnimatedSprite2D = $SharkSprite


func _ready() -> void:
	GameEvent.pause_enemies.connect(paused)


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


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("PlayerBullet"):
		Global.current_points += points_value
		GameEvent.emit_update_points()
		SoundManager.play_sound(SHARK_DEATH)
		area.queue_free()
		queue_free()
	
	if area.is_in_group("Player"):
		area.death()
