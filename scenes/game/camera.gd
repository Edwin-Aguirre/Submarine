extends Camera2D


const FOLLOW_SPEED: int = 9
const MIN_CAMERA_HEIGHT: int = 70
const MAX_CAMERA_HEIGHT: int = 145


var target_position: Vector2 = global_position


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameEvent.camera_follow_player.connect(follow_player)


func _process(delta: float) -> void:
	global_position.y = lerp(global_position.y, target_position.y, FOLLOW_SPEED * delta)


func follow_player(player_y: float) -> void:
	target_position.y = clamp(player_y, MIN_CAMERA_HEIGHT, MAX_CAMERA_HEIGHT)
