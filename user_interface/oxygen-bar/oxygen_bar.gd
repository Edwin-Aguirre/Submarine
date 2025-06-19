extends Node2D


var previous_amount: int = 0


const OXYGEN_ALERT = preload("res://user_interface/oxygen-bar/oxygen_alert.ogg")


@onready var oxygen_bar_texture: TextureProgressBar = $OxygenBarTexture
@onready var flash_timer: Timer = $FlashTimer


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	oxygen_bar_texture.value = Global.oxygen_level
	
	var amount_rounded = round(Global.oxygen_level)
	
	if amount_rounded == previous_amount:
		return
	
	if amount_rounded == 25:
		alert(1.25, 5)
	elif amount_rounded == 15:
		alert(1.3, 7)
	elif amount_rounded == 10:
		alert(1.35, 10)
	elif amount_rounded == 7:
		alert(1.4, 15)
	elif amount_rounded == 5:
		alert(1.5, 20)
	elif amount_rounded == 2:
		alert(1.6, 25)
	elif amount_rounded == 1:
		alert(1.8, 35)
	
	previous_amount = amount_rounded


func alert(scale_value: float, rotation_value: int) -> void:
	scale = Vector2(scale_value, scale_value)
	rotation_degrees = randf_range(-rotation_value, rotation_value)
	modulate = Color(50, 50, 50)
	flash_timer.start()
	SoundManager.play_sound(OXYGEN_ALERT)


func _physics_process(delta: float) -> void:
	scale = lerp(scale, Vector2(1, 1), 6 * delta)
	rotation_degrees = lerp(rotation_degrees, 0.0, 6 * delta)


func _on_flash_timer_timeout() -> void:
	modulate = Color(1, 1, 1)
