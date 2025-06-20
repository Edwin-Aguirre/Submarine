extends Node2D


const SPEED: int = 15


var value: int = 0


@onready var point_label: Label = $PointLabel


func _ready() -> void:
	point_label.text = str(value)
	rotation_degrees = randf_range(0, 360)


func _physics_process(delta: float) -> void:
	global_position.y -= SPEED * delta
	rotation_degrees = lerp(rotation_degrees, 0.0, 18 * delta)
