extends Control


@onready var play_button: Button = $Buttons/PlayButton
@onready var exit_button: Button = $Buttons/ExitButton
@onready var high_score_label: Label = $HighScoreLabel


const ICON = preload("res://icon.svg")
const GAME = preload("res://scenes/game.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play_button.grab_focus()
	high_score_label.text = "HighScore " + str(Global.highscore)


func _on_play_button_focus_entered() -> void:
	play_button.icon = ICON


func _on_play_button_focus_exited() -> void:
	play_button.icon = null


func _on_exit_button_focus_entered() -> void:
	exit_button.icon = ICON


func _on_exit_button_focus_exited() -> void:
	exit_button.icon = null


func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_packed(GAME)
