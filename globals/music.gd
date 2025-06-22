extends Node


const MUSIC = preload("res://music/music.tscn")


func _ready() -> void:
	var new_music = MUSIC.instantiate()
	add_child(new_music)


func change_pitch(amount: float) -> void:
	var music = get_child(0)
	music.pitch_scale = amount


func reset_pitch() -> void:
	var music = get_child(0)
	music.pitch_scale = floor(lerp(music.pitch_scale, 1.0, 60 * get_process_delta_time()))


func playing(check: bool) -> void:
	var music = get_child(0)
	if check == true:
		music.stream_paused = false
	elif check == false:
		music.stream_paused = true
