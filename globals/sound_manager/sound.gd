extends AudioStreamPlayer


func _ready() -> void:
	finished.connect(_finished)


func _finished() -> void:
	queue_free()
