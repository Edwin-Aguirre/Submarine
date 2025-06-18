extends Area2D


const SPEED: int = 50
const MOVEMENT_FREQUENCY: float = 0.15
const MOVEMENT_AMPLITUDE: float = 0.5


var velocity: Vector2 = Vector2.RIGHT
var random_offset: float = randf_range(0.0, 10.0)
var points_value: int = 25


@onready var shark_sprite: AnimatedSprite2D = $SharkSprite


func _physics_process(delta: float) -> void:
	velocity.y = sin(global_position.x * MOVEMENT_FREQUENCY + random_offset) * MOVEMENT_AMPLITUDE
	global_position += velocity * SPEED * delta


func _process(_delta: float) -> void:
	if global_position.x > Global.SCREEN_BOUND_MAX_X or global_position.x < Global.SCREEN_BOUND_MIN_X:
		queue_free()


func flip_shark_direction() -> void:
	velocity = -velocity
	shark_sprite.flip_h = !shark_sprite.flip_h


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("PlayerBullet"):
		Global.current_points += points_value
		GameEvent.emit_update_points()
		area.queue_free()
		queue_free()
	
	if area.is_in_group("Player"):
		GameEvent.emit_game_over()
