extends Area2D


const SPEED: Vector2 = Vector2(125, 90)

const OXYGEN_DECREASE_SPEED: float = 2.5
const OXYGEN_INCREASE_SPEED: float = 60.0
const OXYGEN_REFUEL_Y_POSITION: int = 38
const OXYGEN_REFUEL_MOVE_SPEED: int = 70

const MAX_X_POSITION: int = 248
const MIN_X_POSITION: int = 10
const MAX_Y_POSITION: int = 205
const MIN_Y_POSITION: int = OXYGEN_REFUEL_Y_POSITION

const BULLET_OFFSET: int = 7
const BULLET = preload("res://player/player_bullet/player_bullet.tscn")


var velocity: Vector2 = Vector2.ZERO
var can_shoot: bool = true
var state: String = "default"


@onready var reload_timer: Timer = $ReloadTimer
@onready var player_sprite: AnimatedSprite2D = $PlayerSprite
@onready var decrease_people_timer: Timer = $DecreasePeopleTimer


func _ready() -> void:
	GameEvent.full_crew_oxygen_refuel.connect(full_crew_oxygen_refuel)
	GameEvent.less_people_oxygen_refuel.connect(less_people_oxygen_refuel)
	GameEvent.game_over.connect(game_over)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if state == "default":
		movement(delta)
		flip_player_direction()
		clamp_player_position()
		shooting()
		lose_oxygen(delta)
		death_oxygen_empty()
	elif state == "oxygen_refuel":
		oxygen_refuel(delta)
		move_to_shore_line(delta)
	elif state == "people_refuel":
		move_to_shore_line(delta)
	
	GameEvent.emit_camera_follow_player(global_position.y)


func movement(delta: float) -> void:
	velocity.x = Input.get_axis("move_left", "move_right")
	velocity.y = Input.get_axis("move_up", "move_down")
	
	velocity = velocity.normalized()
	global_position += velocity * SPEED * delta


func flip_player_direction() -> void:
	if velocity.x > 0:
		player_sprite.flip_h = false
	elif velocity.x < 0:
		player_sprite.flip_h = true


func clamp_player_position() -> void:
	global_position.x = clamp(global_position.x, MIN_X_POSITION, MAX_X_POSITION)
	global_position.y = clamp(global_position.y, MIN_Y_POSITION, MAX_Y_POSITION)


func shooting() -> void:
	if Input.is_action_pressed("shoot") and can_shoot:
		var bullet_instance = BULLET.instantiate()
		get_tree().current_scene.add_child(bullet_instance)
		
		if player_sprite.flip_h :
			bullet_instance.flip_bullet_direction()
			bullet_instance.global_position = global_position - Vector2(BULLET_OFFSET, 0)
		else:
			bullet_instance.global_position = global_position + Vector2(BULLET_OFFSET, 0)
		
		reload_timer.start()
		can_shoot = false


func move_to_shore_line(delta: float) -> void:
	var move_speed = OXYGEN_REFUEL_MOVE_SPEED * delta
	global_position.y = move_toward(global_position.y, OXYGEN_REFUEL_Y_POSITION, move_speed)


func lose_oxygen(delta: float) -> void:
	var oxygen_decrease_level = OXYGEN_DECREASE_SPEED * delta
	Global.oxygen_level = move_toward(Global.oxygen_level, 0, oxygen_decrease_level)


func oxygen_refuel(delta: float) -> void:
	Global.oxygen_level += OXYGEN_INCREASE_SPEED * delta
	
	if Global.oxygen_level > 99:
		state = "default"


func death_oxygen_empty() -> void:
	if Global.oxygen_level <= 0:
		GameEvent.emit_game_over()


func death_oxygen_full_refuel() -> void:
	if Global.oxygen_level > 80:
		GameEvent.emit_game_over()


func full_crew_oxygen_refuel() -> void:
	state = "people_refuel"
	decrease_people_timer.start()
	death_oxygen_full_refuel()


func less_people_oxygen_refuel() -> void:
	state = "oxygen_refuel"
	remove_person()
	death_oxygen_full_refuel()


func remove_person():
	if Global.saved_people_count > 0:
		Global.saved_people_count -= 1
		GameEvent.emit_update_collected_people_count()


func game_over() -> void:
	queue_free()


func _on_reload_timer_timeout() -> void:
	can_shoot = true


func _on_decrease_people_timer_timeout() -> void:
	remove_person()
	
	if Global.saved_people_count <= 0:
		state = "oxygen_refuel"
		decrease_people_timer.stop()
