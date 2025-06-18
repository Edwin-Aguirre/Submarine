extends Control


@onready var current_score_label: Label = $CurrentScoreLabel
@onready var high_score_label: Label = $HighScoreLabel
@onready var game_over_delay: Timer = $GameOverDelay


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameEvent.game_over.connect(activate_game_over)
	visible = false


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("shoot") and visible:
		Global.current_points = 0
		Global.saved_people_count = 0
		Global.oxygen_level = 100
		get_tree().reload_current_scene()


func activate_game_over() -> void:
	current_score_label.text = "Score " + str(Global.current_points)
	
	if Global.current_points > Global.highscore:
		Global.highscore = Global.current_points
	
	high_score_label.text = "HighScore " + str(Global.highscore)
	game_over_delay.start()


func _on_game_over_delay_timeout() -> void:
	visible = true
