extends Area2D


const SPEED = 300


var velocity: Vector2 = Vector2.RIGHT


@onready var player_bullet_sprite: AnimatedSprite2D = $PlayerBulletSprite


func _ready() -> void:
	rotation_degrees = randf_range(-7.0, 7.0)
	velocity = velocity.rotated(rotation)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	global_position += velocity * SPEED * delta


func flip_bullet_direction() -> void:
	velocity = -velocity
	player_bullet_sprite.flip_h = !player_bullet_sprite.flip_h


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
