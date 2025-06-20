extends Sprite2D


var velocity: Vector2 = Vector2.RIGHT
var move_speed: int = 150
var rotation_speed: int = 50


func _ready() -> void:
	var random_angle = randf_range(0, TAU)
	velocity = velocity.rotated(random_angle)
	rotation_speed = randi_range(-70, 70)


func _physics_process(delta: float) -> void:
	global_position += velocity * move_speed * delta
	rotation_degrees += rotation_speed * delta
	
	move_speed = lerp(move_speed, 0, 6 * delta)
