extends AnimatedSprite2D


const SPEED: Vector2 = Vector2(125, 90)
const BULLET_OFFSET: int = 7
const BULLET = preload("res://player/player_bullet/player_bullet.tscn")


var velocity: Vector2 = Vector2(0,0)
var can_shoot: bool = true


@onready var reload_timer: Timer = $ReloadTimer


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	velocity.x = Input.get_axis("move_left", "move_right")
	velocity.y = Input.get_axis("move_up", "move_down")
	
	velocity = velocity.normalized()
	
	if velocity.x > 0:
		flip_h = false
	elif velocity.x < 0:
		flip_h = true
	
	
	if Input.is_action_pressed("shoot") and can_shoot:
		var bullet_instance = BULLET.instantiate()
		get_tree().current_scene.add_child(bullet_instance)
		
		if flip_h :
			bullet_instance.flip_bullet_direction()
			bullet_instance.global_position = global_position - Vector2(BULLET_OFFSET, 0)
		else:
			bullet_instance.global_position = global_position + Vector2(BULLET_OFFSET, 0)
		
		reload_timer.start()
		can_shoot = false
	
	
	global_position += velocity * SPEED * delta


func _on_reload_timer_timeout() -> void:
	can_shoot = true
