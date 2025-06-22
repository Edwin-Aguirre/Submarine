extends Node


var saved_people_count: int = 0
var oxygen_level: float = 100.0
var current_points: int = 0
var highscore: int = 0


const SCREEN_BOUND_MAX_X: int = 300
const SCREEN_BOUND_MIN_X: int = -50


const MAIN_MENU = preload("res://main/main_menu.tscn")


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("exit"):
		get_tree().change_scene_to_packed(MAIN_MENU)
