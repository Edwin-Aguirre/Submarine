extends Area2D


const SPEED: int = 25


var velocity: Vector2 = Vector2.RIGHT


@onready var person_sprite: AnimatedSprite2D = $PersonSprite


func _physics_process(delta: float) -> void:
	global_position += velocity * SPEED * delta


func flip_person_direction() -> void:
	velocity = -velocity
	person_sprite.flip_h = !person_sprite.flip_h


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player"):
		Global.saved_people_count += 1
		GameEvent.emit_update_collected_people_count()
		queue_free()
