extends Area2D


const SPEED: Vector2 = Vector2(125, 90)
const ROTATION_STRENGTH: int = 15

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
const PLAYER_SHOOT = preload("res://player/player_bullet/player_shoot.ogg")
const PLAYER_DEATH = preload("res://player/player_death.ogg")
const FULL_OXYGEN_ALERT = preload("res://user_interface/oxygen-bar/full_oxygen_alert.ogg")

const PIECE_COUNT: int = 10
const OBJECT_PIECE = preload("res://particles/object_piece/object_piece.tscn")
const PLAYER_PIECES = preload("res://player/player_pieces.png")

var velocity: Vector2 = Vector2.ZERO
var can_shoot: bool = true
var is_shooting: bool = false
var state = states.DEFAULT


enum states {DEFAULT, PAUSED, OXYGEN_REFUEL, PEOPLE_REFUEL}


@onready var reload_timer: Timer = $ReloadTimer
@onready var player_sprite: AnimatedSprite2D = $PlayerSprite
@onready var decrease_people_timer: Timer = $DecreasePeopleTimer
@onready var bubble_particles: CPUParticles2D = $BubbleParticles


func _ready() -> void:
	GameEvent.full_crew_oxygen_refuel.connect(full_crew_oxygen_refuel)
	GameEvent.less_people_oxygen_refuel.connect(less_people_oxygen_refuel)
	GameEvent.game_over.connect(game_over)
	Music.playing(true)
	Music.change_pitch(1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if state == states.DEFAULT:
		movement(delta)
		rotate_movement(delta)
		flip_player_direction()
		clamp_player_position()
		shooting()
		lose_oxygen(delta)
		death_oxygen_empty()
	elif state == states.OXYGEN_REFUEL:
		oxygen_refuel(delta)
		move_to_shore_line(delta)
	elif state == states.PEOPLE_REFUEL:
		move_to_shore_line(delta)
	
	GameEvent.emit_camera_follow_player(global_position.y)


func movement(delta: float) -> void:
	velocity.x = Input.get_axis("move_left", "move_right")
	velocity.y = Input.get_axis("move_up", "move_down")
	
	velocity = velocity.normalized()
	global_position += velocity * SPEED * delta


func flip_player_direction() -> void:
	if is_shooting == true:
		return
	
	if velocity.x > 0:
		player_sprite.flip_h = false
		bubble_particles.gravity.x = -50
		bubble_particles.position.x = -15
	elif velocity.x < 0:
		player_sprite.flip_h = true
		bubble_particles.gravity.x = 50
		bubble_particles.position.x = 15


func rotate_movement(delta: float) -> void:
	var rotation_target = 0
	
	if velocity.y == 0:
		rotation_target = velocity.x * ROTATION_STRENGTH
	else:
		if player_sprite.flip_h == false:
			rotation_target = velocity.y * ROTATION_STRENGTH
		else:
			rotation_target = -velocity.y * ROTATION_STRENGTH
	
	rotation_degrees = lerp(rotation_degrees, rotation_target, 15 * delta)


func clamp_player_position() -> void:
	global_position.x = clamp(global_position.x, MIN_X_POSITION, MAX_X_POSITION)
	global_position.y = clamp(global_position.y, MIN_Y_POSITION, MAX_Y_POSITION)


func shooting() -> void:
	if Input.is_action_pressed("shoot") and can_shoot:
		var bullet_instance = BULLET.instantiate()
		get_tree().current_scene.add_child(bullet_instance)
		
		SoundManager.play_sound(PLAYER_SHOOT)
		Input.start_joy_vibration(0, 0.25, 0.5, 0)
		
		if player_sprite.flip_h :
			bullet_instance.flip_bullet_direction()
			bullet_instance.global_position = global_position - Vector2(BULLET_OFFSET, 0)
		else:
			bullet_instance.global_position = global_position + Vector2(BULLET_OFFSET, 0)
		
		reload_timer.start()
		can_shoot = false
	
	if Input.is_action_pressed("shoot"):
		is_shooting = true
	else:
		is_shooting = false


func move_to_shore_line(delta: float) -> void:
	var move_speed = OXYGEN_REFUEL_MOVE_SPEED * delta
	global_position.y = move_toward(global_position.y, OXYGEN_REFUEL_Y_POSITION, move_speed)


func lose_oxygen(delta: float) -> void:
	var oxygen_decrease_level = OXYGEN_DECREASE_SPEED * delta
	Global.oxygen_level = move_toward(Global.oxygen_level, 0, oxygen_decrease_level)


func oxygen_refuel(delta: float) -> void:
	Global.oxygen_level += OXYGEN_INCREASE_SPEED * delta
	Music.reset_pitch()
	
	if Global.oxygen_level > 99:
		state = states.DEFAULT
		player_sprite.play("default")
		GameEvent.emit_pause_enemies(false)
		SoundManager.play_sound(FULL_OXYGEN_ALERT)


func death_oxygen_empty() -> void:
	if Global.oxygen_level <= 0:
		death()


func death_oxygen_full_refuel() -> void:
	if Global.oxygen_level > 80 and Global.saved_people_count < 7:
		death()


func full_crew_oxygen_refuel() -> void:
	state = states.PEOPLE_REFUEL
	player_sprite.play("flash")
	decrease_people_timer.start()
	death_oxygen_full_refuel()
	GameEvent.emit_pause_enemies(true)
	GameEvent.emit_kill_all_enemies()


func less_people_oxygen_refuel() -> void:
	state = states.OXYGEN_REFUEL
	player_sprite.play("flash")
	remove_person()
	death_oxygen_full_refuel()
	GameEvent.emit_pause_enemies(true)


func remove_person():
	if Global.saved_people_count > 0:
		Global.saved_people_count -= 1
		GameEvent.emit_update_collected_people_count()


func death() -> void:
	GameEvent.emit_game_over()
	GameEvent.emit_pause_enemies(true)
	SoundManager.play_sound(PLAYER_DEATH)
	player_death_pieces()
	Input.start_joy_vibration(0, 0.5, 1.0, 0.5)


func player_death_pieces() -> void:
	for i in range(PIECE_COUNT):
		var player_pieces_instance = OBJECT_PIECE.instantiate()
		
		player_pieces_instance.texture = PLAYER_PIECES
		player_pieces_instance.hframes = PIECE_COUNT
		player_pieces_instance.frame = i
		
		get_tree().current_scene.add_child(player_pieces_instance)
		player_pieces_instance.global_position = global_position


func game_over() -> void:
	queue_free()


func _on_reload_timer_timeout() -> void:
	can_shoot = true
	Input.stop_joy_vibration(0)


func _on_decrease_people_timer_timeout() -> void:
	remove_person()
	
	if Global.saved_people_count <= 0:
		state = states.OXYGEN_REFUEL
		decrease_people_timer.stop()
